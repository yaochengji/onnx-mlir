// RUN: onnx-mlir --maccel=NNPA  --printIR --EmitZHighIR --instrument-stage=nnpa-before-onnx-to-zhigh --instrument-ops=onnx. --InstrumentBeforeOp --InstrumentAfterOp --InstrumentReportTime %s | FileCheck %s

func.func @test_instrument_add_onnx(%arg0 : tensor<10x10xf32>, %arg1 : tensor<10x10xf32>) -> tensor<*xf32> {
  %0 = "onnx.Add"(%arg0, %arg1) : (tensor<10x10xf32>, tensor<10x10xf32>) -> tensor<*xf32>
  "func.return"(%0) : (tensor<*xf32>) -> ()
}

// CHECK-LABEL:  func.func @test_instrument_add_onnx
// CHECK:           "krnl.runtime_instrument"() {opName = "onnx.Add", tag = 5 : i64} : () -> ()
// CHECK:           "zhigh.Stick"
// CHECK:           "zhigh.Stick"
// CHECK:           "zhigh.Add"
// CHECK:           "zhigh.Unstick"
// CHECK:           "krnl.runtime_instrument"() {opName = "onnx.Add", tag = 6 : i64} : () -> ()
// CHECK:           return
// CHECK:         }

// -----
