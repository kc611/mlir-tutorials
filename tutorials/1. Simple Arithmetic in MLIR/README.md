# Introduction

<b>Welcome to this tutorial series....</b>

The Numba team at Anaconda recently started work on a project to build cutting edge compiler tooling using  Multi-Level Intermidiate Representation (widely known as the MLIR framework). Henceforth, as an introductory resource, these are a series of tutorials produced as a effort towards getting folks familiarized with the MLIR framework. We'll also discuss why it was built, it's purpose and usage within industry.

# What is MLIR?

MLIR stands for Multi-Level Intermidiate Representation and as the name suggests the general idea/philosophy is that a language compiler can be broken up into lots of intermidiate stages, each on top of one another, each represented by its own sub-language called an IR or an Intermidiate Representation. The general idea is that as the logic moves down or is `lowered` into the representations it loses the high level context to make certain kinds of optimizations. Henceforth, These optimizations are targeted to be made at level where; we still have enough context within the logic to make them and yet are low level enough such that it is natural to express and make these optimizations.

# MLIR Dialects and Lowering:

Two terms that comes up a lot while working with MLIR projects are dialect and lowering. Dialect as the same suggests is the representation or the IR of the logic. While in traditional compiler we only had one dialect (this exists within the compiler itself); in MLIR we have multiple IRs each can be described as a dialect. 

These dialects are then arranged on top of one another with the highest level on top (this is usually the language) and assembly/binary code at the lower end. The logic is then transformed from each of the higher level dialect to its immdiate next lower level dialect. This process is called lowering because the logic is being 'lowered' into a optimizable and eventually machine readable low level form. 

# How does MLIR work?

Imagine the compiler being an assembly line, with the highest dialect being the rough framework of the product and lowest dialect to be machine code or in our case LLVM-IR (also known as Low-Level Virtual Machine) which can then be executed by compiling it into binary file using different tooling and executing it. Each dialect represents each machine at the assembly line. Each having it's own set of bits and pieces, or optimizations, that it carves into the final product. These bits and pieces are carved in form of optimization passes and the dialect for each machine is specifically built in a way that it makes these optimization passes much simpler to execute. There's not any distinction between optimization passes and lowering passes so the same kind of pass infrastructure is used to perform operations within a certain dialect and to tranform the logic from one dialect to another. In MLIR these passes are represented in form of generic IR modules

A big part of the motivation for MLIR and also the final goal of these tutorial series is to understand and build the affine dialect, which is specifically designed to enable polyhedral optimizations for loop transformations, along with the linalg dialect, which does optimization passes like tiling for low-level ML operations on specialized hardware like GPUs. 

# Setting up a basic environment for MLIR

Let us start with building a simple program in MLIR that does the Fused-Multiply-Add ([math::fma](https://mlir.llvm.org/docs/Dialects/MathOps/#mathfma-mathfmaop)) operation which basically takes in three floating point numbers `a`, `b` and `c` and results in `a * b + c`.

We'll first need to set up a conda to make our own virtual environment for the project. If you don't already have conda installed please follow instructions at the [conda installation guide](https://docs.conda.io/projects/conda/en/stable/user-guide/install/index.html). 

Assuming you can run `conda --version` in your terminal now. Proceed to build and activate a conda environment as follows:

```
conda create --name mlir_tutorial python=3.12
conda activate mlir_tutorial
```

Next you'll be needing various packages from conda such as `mlir` itself, `llvmlite` and `llvmdev` (and `llvm-tools`) for executing the generated LLVM-IR (more on this later)

Proceed to install them as follows:

```
conda install mlir llvmlite
```

All the required packages get installed as dependencies automatically. 

# A basic function written in MLIR

We can write a example function named `test_fma` using the `func`, `arith` and `math` dialect as follows:

```mlir
func.func @test_fma() -> f64 {
  %arg1 = arith.constant 1.0 : f64
  %arg2 = arith.constant 2.0 : f64
  %arg3 = arith.constant 3.0 : f64
  %res = math.fma %arg1, %arg2, %arg3: f64
  func.return %res : f64
}
```

and save it in a file `test_fma.mlir`. This will serve as the highest dialect of our compiler pipeline for this tutorial and will be lowered using multiple pass optimizations.


We can see that the function represented by `@test_fma()` returns a 64-bit floating-point or an`f64` type value as declared within its type definition: 

```
func.func @test_fma() -> f64 {}
```

This declaration uses the `func` dialect which is one of the built-in dialects within MLIR framework. (See [`FuncOps`](https://mlir.llvm.org/docs/Dialects/Func/#funcfunc-funcfuncop) for more details) For simple visualizations imagine the dialects as built-in packages/standard libraries within MLIR that holds abstractions of logic which can be mapped onto a different form of abstraction representing the same logic.

Within the function we declare 3 variables `%arg1`, `%arg2` and `%arg3` each being a constant of type `f64`. 

```
  %arg1 = arith.constant 1.0 : f64
  %arg2 = arith.constant 2.0 : f64
  %arg3 = arith.constant 3.0 : f64
```
These constant declarations are part of the `arith` dialect which is again a built-in dialect within the MLIR project that holds basic integer and floating point operations. (See [`MLIR::ArithOps`](https://mlir.llvm.org/docs/Dialects/ArithOps/) for details)

Next we declare a variable `res` representing the result of `math.fma` operation to which we supply the three arguments `%arg1`, `%arg2` and `%arg3` respectively and assign it the type `f64` too.

```
  %res = math.fma %arg1, %arg2, %arg3: f64
```

The `math` is yet another dialect built-in into the MLIR project that holds complex mathematical operations beyond basic integer declaration and manipulation. (See [`MLIR::MathOps`](https://mlir.llvm.org/docs/Dialects/MathOps/) for details)

And finally we return the resulting value:
```
  func.return %res : f64
```

Note that in the above example we have simply declared the entry points for different dialects (namely `func`, `arith` and `math` in our case) and have not yet run any optimization or conversion passes. Hence this is the unlowered form without any dialect specific transformations.

# Usage of different dialects

Now we'll use the tools provided by `mlir` conda package to optimize the MLIR we've built into LLVM-IR dialect using `mlir-opt` which serves as the entry point for the MLIR optimization pass infrastucture. 

For our example we'll need two optimization passes, namely `convert-func-to-llvm` and `convert-math-to-llvm`. As the name suggests these two optimization passes convert the very specific entry points for the respective dialect declarations into a form that is consumable by the llvm translation dialect. 

Along with these two arguments we'll also pass in a special flag called `--mlir-print-ir-after-all`. This makes the transformations easier to visualize by printing the IR after each optimization pass has been made. 

So the final command comes out as follows:

```
mlir-opt test_fma.mlir --mlir-print-ir-after-all --convert-func-to-llvm --convert-math-to-llvm
```

This command, if run sucessfully, should give an output as follows:

```
// -----// IR Dump After ConvertFuncToLLVMPass (convert-func-to-llvm) //----- //
module attributes {llvm.data_layout = ""} {
  llvm.func @test_fma() -> f64 {
    %0 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %1 = llvm.mlir.constant(2.000000e+00 : f64) : f64
    %2 = llvm.mlir.constant(3.000000e+00 : f64) : f64
    %3 = math.fma %0, %1, %2 : f64
    llvm.return %3 : f64
  }
}


// -----// IR Dump After ConvertMathToLLVMPass (convert-math-to-llvm) //----- //
module attributes {llvm.data_layout = ""} {
  llvm.func @test_fma() -> f64 {
    %0 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %1 = llvm.mlir.constant(2.000000e+00 : f64) : f64
    %2 = llvm.mlir.constant(3.000000e+00 : f64) : f64
    %3 = llvm.intr.fma(%0, %1, %2)  : (f64, f64, f64) -> f64
    llvm.return %3 : f64
  }
}


module attributes {llvm.data_layout = ""} {
  llvm.func @test_fma() -> f64 {
    %0 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %1 = llvm.mlir.constant(2.000000e+00 : f64) : f64
    %2 = llvm.mlir.constant(3.000000e+00 : f64) : f64
    %3 = llvm.intr.fma(%0, %1, %2)  : (f64, f64, f64) -> f64
    llvm.return %3 : f64
  }
}
```

Now let's disseminate the output.

First you'll notice the changes done by `convert-func-to-llvm` translation pass within:

```
// -----// IR Dump After ConvertFuncToLLVMPass (convert-func-to-llvm) /------ //
module attributes {llvm.data_layout = ""} {
  llvm.func @test_fma() -> f64 {
    %0 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %1 = llvm.mlir.constant(2.000000e+00 : f64) : f64
    %2 = llvm.mlir.constant(3.000000e+00 : f64) : f64
    %3 = math.fma %0, %1, %2 : f64
    llvm.return %3 : f64
  }
}
```

Notice that all references to the `func` and `arith` have been replaced with `llvm` references. These map directly to specifc LLVM-IR logic/operations making it so that it is easily consumable for the translation pass to LLVM-IR.

Next the `convert-math-to-llvm` pass does the follows: 

```
// -----// IR Dump After ConvertMathToLLVMPass (convert-math-to-llvm) //----- //
module attributes {llvm.data_layout = ""} {
  llvm.func @test_fma() -> f64 {
    %0 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %1 = llvm.mlir.constant(2.000000e+00 : f64) : f64
    %2 = llvm.mlir.constant(3.000000e+00 : f64) : f64
    %3 = llvm.intr.fma(%0, %1, %2)  : (f64, f64, f64) -> f64
    llvm.return %3 : f64
  }
}
```

Replacing the `arith` dialect with the `llvm` one.

# MLIR to LLVM-IR translation

Now we have the final IR after all the optimization passes as:

```
module attributes {llvm.data_layout = ""} {
  llvm.func @test_fma() -> f64 {
    %0 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %1 = llvm.mlir.constant(2.000000e+00 : f64) : f64
    %2 = llvm.mlir.constant(3.000000e+00 : f64) : f64
    %3 = llvm.intr.fma(%0, %1, %2)  : (f64, f64, f64) -> f64
    llvm.return %3 : f64
  }
}
```

And save this into a file named `test_fma_opt.mlir`.

Next we have the command `mlir-translate` which hold the passes that translate from one IR to another, in our case, we'll be using it to transform our IR into LLVM-IR.

To do this, we use the pass `--mlir-to-llvmir`. Hence the entire command is as follows:

```
mlir-translate test_fma_opt.mlir --mlir-to-llvmir
```

Which should give you output as follows:

```
; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

declare ptr @malloc(i64)

declare void @free(ptr)

define double @test_fma() {
  %1 = call double @llvm.fma.f64(double 1.000000e+00, double 2.000000e+00, double 3.000000e+00)
  ret double %1
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.fma.f64(double, double, double) #0

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
```

This is the LLVM-IR the representation used by the LLVM project. (See [`LLVM LangRef`](https://llvm.org/docs/LangRef.html) for detailed documentation or the IR)

We can save this into a file `test_fma.ll` as follows:

```
mlir-translate test_fma_opt.mlir --mlir-to-llvmir | tee test_fma.ll
```

# Executing the LLVM-IR

Now we have the LLVM-IR for our original FMA function. This IR can now be executed in various ways, let's explore some of the ways in which the execution can happen to test out out code. 

### Using `llvm` build tools

To compile the generated LLVM IR into an object file, we can use the LLVM provisioned `llc` compiler as follows:

```
llc -filetype=obj test_fma.ll -o test_fma.o
```

This generates a `.o` object file that needs to be further converted to a `.so` shared object file that can be imported elsewhere. This can be done with using a object code linker specific to your system, for linux it's `gcc`. Fortunately `conda` provides a simple eviroment variable `$CC` which redirects the commands to whatever linker is present in the current conda environment depending on the system. This is done as follows:

```
$CC -shared test_fma.o -o libtest_fma.so
```

This generates the required `.so` file that can be imported within your project. In Python for instance this can be done using `ctypes`:

```
import ctypes

module = ctypes.CDLL('./libtest_fma.so')
module.test_fma.argtypes = []
module.test_fma.restype = ctypes.c_double

def test_fma():
    return module.test_fma()

print(test_fma())
# Outputs: 5.0
```

## Using `llvmlite`

Alternatively, We can use `llvmlite` to execute the LLVM-IR using it's inbuilt execution engine as follows:

(Note that if you're using llvmlite you'd need to do some modifications to the `.ll` file in this example, namely you'd need to remove the declarations `declare ptr @malloc(i64)` and `declare void @free(ptr)`, as weel as `memory(none)` where-ever present. This is because `llvmlite` currently uses LLVM-15 while the `mlir` package emits IR made for LLVM-17) 

```
from __future__ import print_function

from ctypes import CFUNCTYPE, c_double

import llvmlite.binding as llvm

import llvmlite

print(llvmlite.__version__)

llvm.initialize()
llvm.initialize_native_target()
llvm.initialize_native_asmprinter()

with open('test_fma.ll', 'r') as file:
    llvm_ir = file.read()

print(llvm_ir)

def create_execution_engine():
    """
    Create an ExecutionEngine suitable for JIT code generation on
    the host CPU.  The engine is reusable for an arbitrary number of
    modules.
    """
    # Create a target machine representing the host
    target = llvm.Target.from_default_triple()
    target_machine = target.create_target_machine()
    # And an execution engine with an empty backing module
    backing_mod = llvm.parse_assembly("")
    engine = llvm.create_mcjit_compiler(backing_mod, target_machine)
    return engine


def compile_ir(engine, llvm_ir):
    """
    Compile the LLVM IR string with the given engine.
    The compiled module object is returned.
    """
    # Create a LLVM module object from the IR
    mod = llvm.parse_assembly(llvm_ir)
    mod.verify()
    # Now add the module and make sure it is ready for execution
    engine.add_module(mod)
    engine.finalize_object()
    engine.run_static_constructors()
    return mod


engine = create_execution_engine()
mod = compile_ir(engine, llvm_ir)

# Look up the function pointer (a Python int)
func_ptr = engine.get_function_address("test_fma")

# Run the function via ctypes
cfunc = CFUNCTYPE(c_double)(func_ptr)
res = cfunc()
print("test_fma output =", res)
# test_fma output = 5.0
```

