; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=knl -mattr=+avx512bw | FileCheck %s

define <64 x i8> @test1(i8 * %addr) {
; CHECK-LABEL: test1:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vmovups (%rdi), %zmm0
; CHECK-NEXT:    retq
  %vaddr = bitcast i8* %addr to <64 x i8>*
  %res = load <64 x i8>, <64 x i8>* %vaddr, align 1
  ret <64 x i8>%res
}

define void @test2(i8 * %addr, <64 x i8> %data) {
; CHECK-LABEL: test2:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vmovups %zmm0, (%rdi)
; CHECK-NEXT:    retq
  %vaddr = bitcast i8* %addr to <64 x i8>*
  store <64 x i8>%data, <64 x i8>* %vaddr, align 1
  ret void
}

define <64 x i8> @test3(i8 * %addr, <64 x i8> %old, <64 x i8> %mask1) {
; CHECK-LABEL: test3:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpxord %zmm2, %zmm2, %zmm2
; CHECK-NEXT:    vpcmpneqb %zmm2, %zmm1, %k1
; CHECK-NEXT:    vmovdqu8 (%rdi), %zmm0 {%k1}
; CHECK-NEXT:    retq
  %mask = icmp ne <64 x i8> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <64 x i8>*
  %r = load <64 x i8>, <64 x i8>* %vaddr, align 1
  %res = select <64 x i1> %mask, <64 x i8> %r, <64 x i8> %old
  ret <64 x i8>%res
}

define <64 x i8> @test4(i8 * %addr, <64 x i8> %mask1) {
; CHECK-LABEL: test4:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpxord %zmm1, %zmm1, %zmm1
; CHECK-NEXT:    vpcmpneqb %zmm1, %zmm0, %k1
; CHECK-NEXT:    vmovdqu8 (%rdi), %zmm0 {%k1} {z}
; CHECK-NEXT:    retq
  %mask = icmp ne <64 x i8> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <64 x i8>*
  %r = load <64 x i8>, <64 x i8>* %vaddr, align 1
  %res = select <64 x i1> %mask, <64 x i8> %r, <64 x i8> zeroinitializer
  ret <64 x i8>%res
}

define <32 x i16> @test5(i8 * %addr) {
; CHECK-LABEL: test5:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vmovups (%rdi), %zmm0
; CHECK-NEXT:    retq
  %vaddr = bitcast i8* %addr to <32 x i16>*
  %res = load <32 x i16>, <32 x i16>* %vaddr, align 1
  ret <32 x i16>%res
}

define void @test6(i8 * %addr, <32 x i16> %data) {
; CHECK-LABEL: test6:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vmovups %zmm0, (%rdi)
; CHECK-NEXT:    retq
  %vaddr = bitcast i8* %addr to <32 x i16>*
  store <32 x i16>%data, <32 x i16>* %vaddr, align 1
  ret void
}

define <32 x i16> @test7(i8 * %addr, <32 x i16> %old, <32 x i16> %mask1) {
; CHECK-LABEL: test7:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpxord %zmm2, %zmm2, %zmm2
; CHECK-NEXT:    vpcmpneqw %zmm2, %zmm1, %k1
; CHECK-NEXT:    vmovdqu16 (%rdi), %zmm0 {%k1}
; CHECK-NEXT:    retq
  %mask = icmp ne <32 x i16> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <32 x i16>*
  %r = load <32 x i16>, <32 x i16>* %vaddr, align 1
  %res = select <32 x i1> %mask, <32 x i16> %r, <32 x i16> %old
  ret <32 x i16>%res
}

define <32 x i16> @test8(i8 * %addr, <32 x i16> %mask1) {
; CHECK-LABEL: test8:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpxord %zmm1, %zmm1, %zmm1
; CHECK-NEXT:    vpcmpneqw %zmm1, %zmm0, %k1
; CHECK-NEXT:    vmovdqu16 (%rdi), %zmm0 {%k1} {z}
; CHECK-NEXT:    retq
  %mask = icmp ne <32 x i16> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <32 x i16>*
  %r = load <32 x i16>, <32 x i16>* %vaddr, align 1
  %res = select <32 x i1> %mask, <32 x i16> %r, <32 x i16> zeroinitializer
  ret <32 x i16>%res
}

define <16 x i8> @test_mask_load_16xi8(<16 x i1> %mask, <16 x i8>* %addr, <16 x i8> %val) {
; CHECK-LABEL: test_mask_load_16xi8:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpsllw $7, %xmm0, %xmm0
; CHECK-NEXT:    vpmovb2m %zmm0, %k0
; CHECK-NEXT:    kshiftlq $48, %k0, %k0
; CHECK-NEXT:    kshiftrq $48, %k0, %k1
; CHECK-NEXT:    vmovdqu8 (%rdi), %zmm0 {%k1} {z}
; CHECK-NEXT:    ## kill: %XMM0<def> %XMM0<kill> %ZMM0<kill>
; CHECK-NEXT:    retq
  %res = call <16 x i8> @llvm.masked.load.v16i8(<16 x i8>* %addr, i32 4, <16 x i1>%mask, <16 x i8> undef)
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.masked.load.v16i8(<16 x i8>*, i32, <16 x i1>, <16 x i8>)

define <32 x i8> @test_mask_load_32xi8(<32 x i1> %mask, <32 x i8>* %addr, <32 x i8> %val) {
; CHECK-LABEL: test_mask_load_32xi8:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpsllw $7, %ymm0, %ymm0
; CHECK-NEXT:    vpmovb2m %zmm0, %k0
; CHECK-NEXT:    kshiftlq $32, %k0, %k0
; CHECK-NEXT:    kshiftrq $32, %k0, %k1
; CHECK-NEXT:    vmovdqu8 (%rdi), %zmm0 {%k1} {z}
; CHECK-NEXT:    ## kill: %YMM0<def> %YMM0<kill> %ZMM0<kill>
; CHECK-NEXT:    retq
  %res = call <32 x i8> @llvm.masked.load.v32i8(<32 x i8>* %addr, i32 4, <32 x i1>%mask, <32 x i8> zeroinitializer)
  ret <32 x i8> %res
}
declare <32 x i8> @llvm.masked.load.v32i8(<32 x i8>*, i32, <32 x i1>, <32 x i8>)

define <8 x i16> @test_mask_load_8xi16(<8 x i1> %mask, <8 x i16>* %addr, <8 x i16> %val) {
; CHECK-LABEL: test_mask_load_8xi16:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpsllw $15, %xmm0, %xmm0
; CHECK-NEXT:    vpmovw2m %zmm0, %k0
; CHECK-NEXT:    kshiftld $24, %k0, %k0
; CHECK-NEXT:    kshiftrd $24, %k0, %k1
; CHECK-NEXT:    vmovdqu16 (%rdi), %zmm0 {%k1} {z}
; CHECK-NEXT:    ## kill: %XMM0<def> %XMM0<kill> %ZMM0<kill>
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.masked.load.v8i16(<8 x i16>* %addr, i32 4, <8 x i1>%mask, <8 x i16> undef)
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.masked.load.v8i16(<8 x i16>*, i32, <8 x i1>, <8 x i16>)

define <16 x i16> @test_mask_load_16xi16(<16 x i1> %mask, <16 x i16>* %addr, <16 x i16> %val) {
; CHECK-LABEL: test_mask_load_16xi16:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpsllw $7, %xmm0, %xmm0
; CHECK-NEXT:    vpmovb2m %zmm0, %k0
; CHECK-NEXT:    kshiftld $16, %k0, %k0
; CHECK-NEXT:    kshiftrd $16, %k0, %k1
; CHECK-NEXT:    vmovdqu16 (%rdi), %zmm0 {%k1} {z}
; CHECK-NEXT:    ## kill: %YMM0<def> %YMM0<kill> %ZMM0<kill>
; CHECK-NEXT:    retq
  %res = call <16 x i16> @llvm.masked.load.v16i16(<16 x i16>* %addr, i32 4, <16 x i1>%mask, <16 x i16> zeroinitializer)
  ret <16 x i16> %res
}
declare <16 x i16> @llvm.masked.load.v16i16(<16 x i16>*, i32, <16 x i1>, <16 x i16>)

define void @test_mask_store_16xi8(<16 x i1> %mask, <16 x i8>* %addr, <16 x i8> %val) {
; CHECK-LABEL: test_mask_store_16xi8:
; CHECK:       ## BB#0:
; CHECK-NEXT:    ## kill: %XMM1<def> %XMM1<kill> %ZMM1<def>
; CHECK-NEXT:    vpsllw $7, %xmm0, %xmm0
; CHECK-NEXT:    vpmovb2m %zmm0, %k0
; CHECK-NEXT:    kshiftlq $48, %k0, %k0
; CHECK-NEXT:    kshiftrq $48, %k0, %k1
; CHECK-NEXT:    vmovdqu8 %zmm1, (%rdi) {%k1}
; CHECK-NEXT:    retq
  call void @llvm.masked.store.v16i8(<16 x i8> %val, <16 x i8>* %addr, i32 4, <16 x i1>%mask)
  ret void
}
declare void @llvm.masked.store.v16i8(<16 x i8>, <16 x i8>*, i32, <16 x i1>)

define void @test_mask_store_32xi8(<32 x i1> %mask, <32 x i8>* %addr, <32 x i8> %val) {
; CHECK-LABEL: test_mask_store_32xi8:
; CHECK:       ## BB#0:
; CHECK-NEXT:    ## kill: %YMM1<def> %YMM1<kill> %ZMM1<def>
; CHECK-NEXT:    vpsllw $7, %ymm0, %ymm0
; CHECK-NEXT:    vpmovb2m %zmm0, %k0
; CHECK-NEXT:    kshiftlq $32, %k0, %k0
; CHECK-NEXT:    kshiftrq $32, %k0, %k1
; CHECK-NEXT:    vmovdqu8 %zmm1, (%rdi) {%k1}
; CHECK-NEXT:    retq
  call void @llvm.masked.store.v32i8(<32 x i8> %val, <32 x i8>* %addr, i32 4, <32 x i1>%mask)
  ret void
}
declare void @llvm.masked.store.v32i8(<32 x i8>, <32 x i8>*, i32, <32 x i1>)

define void @test_mask_store_8xi16(<8 x i1> %mask, <8 x i16>* %addr, <8 x i16> %val) {
; CHECK-LABEL: test_mask_store_8xi16:
; CHECK:       ## BB#0:
; CHECK-NEXT:    ## kill: %XMM1<def> %XMM1<kill> %ZMM1<def>
; CHECK-NEXT:    vpsllw $15, %xmm0, %xmm0
; CHECK-NEXT:    vpmovw2m %zmm0, %k0
; CHECK-NEXT:    kshiftld $24, %k0, %k0
; CHECK-NEXT:    kshiftrd $24, %k0, %k1
; CHECK-NEXT:    vmovdqu16 %zmm1, (%rdi) {%k1}
; CHECK-NEXT:    retq
  call void @llvm.masked.store.v8i16(<8 x i16> %val, <8 x i16>* %addr, i32 4, <8 x i1>%mask)
  ret void
}
declare void @llvm.masked.store.v8i16(<8 x i16>, <8 x i16>*, i32, <8 x i1>)

define void @test_mask_store_16xi16(<16 x i1> %mask, <16 x i16>* %addr, <16 x i16> %val) {
; CHECK-LABEL: test_mask_store_16xi16:
; CHECK:       ## BB#0:
; CHECK-NEXT:    ## kill: %YMM1<def> %YMM1<kill> %ZMM1<def>
; CHECK-NEXT:    vpsllw $7, %xmm0, %xmm0
; CHECK-NEXT:    vpmovb2m %zmm0, %k0
; CHECK-NEXT:    kshiftld $16, %k0, %k0
; CHECK-NEXT:    kshiftrd $16, %k0, %k1
; CHECK-NEXT:    vmovdqu16 %zmm1, (%rdi) {%k1}
; CHECK-NEXT:    retq
  call void @llvm.masked.store.v16i16(<16 x i16> %val, <16 x i16>* %addr, i32 4, <16 x i1>%mask)
  ret void
}
declare void @llvm.masked.store.v16i16(<16 x i16>, <16 x i16>*, i32, <16 x i1>)
