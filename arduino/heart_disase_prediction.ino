#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>

#include <Arduino.h>

#include <TensorFlowLite_ESP32.h>

// Import TensorFlow stuff
#include "tensorflow/lite/micro/all_ops_resolver.h" #모델에 포함된 모든 연산을 사용할 수 있도록 설정
#include "tensorflow/lite/micro/micro_error_reporter.h" #모델 실행 중 발생하는 디버그 정보를 출력
#include "tensorflow/lite/micro/micro_interpreter.h" #모델을 실행하기 위한 관련 클래스와 함수를 정의
#include "tensorflow/lite/micro/system_setup.h" #시스템 설정을 초기화하고 모델을 실행하기 위한 기본 구성을 수행
#include "tensorflow/lite/schema/schema_generated.h" #스키마(schema) 정보를 포함
#include "tensorflow/lite/micro/kernels/micro_ops.h"

// Our model
#include "model.h"
#include "main_functions.h"
#include "model.h"
#include "constants.h"
#include "output_handler.h"

//bluetooth seting
#define SERVICE_UUID        "d3aaa81a-4bfb-11ee-be56-0242ac120002"
#define CHARACTERISTIC_UUID "001e5dc2-a8df-4f99-8d38-2f90f3ba5e42"

// BLE통신을 통해 휴대폰에서 받는 값
float sex = 1;
float age = 30;
float currentsmoke = 0;
float prevalenthyp = 0;
float diabetes = 1;
float bmi = 25.52;

//variables for BLE connection 
BLECharacteristic *pCharacteristic;
bool deviceConnected = false;

class MyServerCallbacks: public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) {
    deviceConnected = true;
  };
  
  void onDisconnect(BLEServer* pServer) {
    deviceConnected = false;
  }
};

//데이터 받기
class MyCallbacks: public BLECharacteristicCallbacks {  
    void onWrite(BLECharacteristic *pCharacteristic) {
      //onWrite 외부에서 데이터를 보내오면 호출됨 
      //보내온 데이터를 변수에 데이터 저장
      std::string rxValue = pCharacteristic->getValue();
      //데이터가 있다면..
      if (rxValue.length() > 0) {
        sex = rxValue[0];

        for(int i=2; i<4; i++)
          age = rxValue[i];

        currentsmoke = rxValue[5];
        prevalenthyp = rxValue[7];
        diabetes = rxValue[9];

        for(int i=11; i <= rxValue.length(); i++)
          bmi = rxValue[i];
      }
    }
};

const int sampleInterval = 1000;  // 샘플링 간격 (밀리초)
unsigned long lastSampleTime = 0;

// Globals, used for compatibility with Arduino-style sketches.
namespace {
  tflite::ErrorReporter* error_reporter = nullptr;
  const tflite::Model* model = nullptr;
  tflite::MicroInterpreter* interpreter = nullptr;
  TfLiteTensor* input = nullptr;
  TfLiteTensor* output = nullptr;
  int inference_count = 0;
  constexpr int kTensorArenaSize = 2000;
  uint8_t tensor_arena[kTensorArenaSize];
}

void setup() {
//블루투스 연결
Serial.begin(115200);
  Serial.println("Starting BLE work!");

  BLEDevice::init("XIAO_ESP32S3");
  BLEServer *pServer = BLEDevice::createServer();
  BLEService *pService = pServer->createService(SERVICE_UUID);
  BLECharacteristic *pCharacteristic = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID,
                                         BLECharacteristic::PROPERTY_READ |
                                         BLECharacteristic::PROPERTY_WRITE
                                       );

  pCharacteristic->setValue("Hello World");
  pService->start();
  // BLEAdvertising *pAdvertising = pServer->getAdvertising();  // this still is working for backward compatibility
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();
  Serial.println("Characteristic defined! Now you can read it in your phone!");

  // Create a callback function to receive data from the client.
  class BLECharacteristicCallback : public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic) {
      std::string value = pCharacteristic->getValue();
      if (value.length() > 0) {
        Serial.print("Received value: ");
        for (int i = 0; i < value.length(); i++) {
          Serial.print(value[i]);
        }
        Serial.println();
      }
    }
  };
  //get heartbeat value
  int heartValue = analogRead(A0);
  //Serial.begin(9600);
  // 로깅 설정
  static tflite::MicroErrorReporter micro_error_reporter;
  error_reporter = &micro_error_reporter;

  // 모델 로딩
  model = tflite::GetModel(h_model);
  if (model->version() != TFLITE_SCHEMA_VERSION) {
    // 모델 버전이 지원 버전과 다를 경우 오류 메시지 출력
    TF_LITE_REPORT_ERROR(error_reporter, "Model provided is schema version %d not equal to supported version %d.", model->version(), TFLITE_SCHEMA_VERSION);
    return;
}

  // 오퍼레이션 리졸버 생성
  static tflite::AllOpsResolver resolver;

  // 인터프리터 초기화 및 텐서 할당
  static tflite::MicroInterpreter static_interpreter(
      model, resolver, tensor_arena, kTensorArenaSize, error_reporter);

  interpreter = &static_interpreter;

  TfLiteStatus allocate_status = interpreter->AllocateTensors();
  if (allocate_status != kTfLiteOk) {
    // 텐서 할당 오류 처리
    TF_LITE_REPORT_ERROR(error_reporter, "AllocateTensors() failed");
    return;
  }

  // 모델의 입력 및 출력 텐서에 대한 포인터 얻기
  input = interpreter->input(0);
  output = interpreter->output(0);

  // 추론 횟수 초기화
  inference_count = 0;
};


void loop(){
  // x 값을 계산하여 모델에 입력으로 전달 *입력값이 float형식으로 7개로 구성된 배열로 들어옴
  float position = static_cast<float>(inference_count) /
                  static_cast<float>(kInferencesPerCycle);
  // PPG 센서에서 읽은 값
  float ppgValue = 85;

  // 모델의 입력 값 Ex) 1,40,0,1,0,22.45,79
  float x_values[7] = {sex, age, currentsmoke, prevalenthyp, diabetes, bmi, ppgValue};
  float x = x_values[inference_count];

  // x_values의 모든 요소를 int8 타입으로 변환
  int8 x_values_int8[7];
  for (int i = 0; i < 7; i++) {
    x_values_int8[i] = (int8)x_values[i];
  }

  // x_values_int8을 input 구조체의 data 필드에 할당
  input->data.f = x_values;

  // 추론 실행 및 오류 처리
  TfLiteStatus invoke_status = interpreter->Invoke();
  if (invoke_status != kTfLiteOk) {
    TF_LITE_REPORT_ERROR(error_reporter, "Invoke failed on x: %f\n", (x_values));
  return;
  }

  // 모델의 출력 값을 얻어서 저장
  float* y = output->data.f;

  // 결과 출력
  HandleOutput(error_reporter,x, *y);
  Serial.print("y = ");
  Serial.println(*y);

  // 추론 횟수 증가 및 초기화
  inference_count += 1;
  if (inference_count >= kInferencesPerCycle) inference_count = 0;
  /*
  uint8_t value[10];
  float result = *y;
  uint8_t r;
  r = uint8_t(result);
  itoa(ppgValue, value, 10);*/
  
  //데이터값 전달
  if (deviceConnected) {
      pCharacteristic->setValue(ppgValue);
      pCharacteristic->setValue(*y);
      delay(100); // bluetooth stack will go into congestion, if too many packets are sent
  }
  
  /*
  unsigned long currentTime = millis();

  // 일정 간격으로 PPG 값을 읽어옴
  if (currentTime - lastSampleTime >= sampleInterval) {
    int ppgPin = 8;// PPG 센서 연결된 아날로그 핀 번호
    lastSampleTime = currentTime;

    float ppgValue = analogRead(ppgPin);  // PPG 값 읽기
    float bpm = calculateBPM(ppgValue);   // BPM 계산

    Serial.println("BPM: " + String(bpm));
  }*/
}