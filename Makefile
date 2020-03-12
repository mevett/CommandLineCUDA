#This Makefile is designed to be located in the same directory as your source code

CC=/usr/bin/g++
NVCC=/usr/local/cuda/bin/nvcc
CXXFLAGS= -O3 -Wextra -std=c++11
CUDAFLAGS= --relocatable-device-code=false -gencode arch=compute_60,code=compute_60 -gencode arch=compute_60,code=sm_60  
#If you wanted to link any external libraries, they should be listed here, e.g:
#LIBS= -lopenblas -lpthread -lcudart -lcublas
LIBS=
#This indicates additional directories where libraries may be found
LIBDIRS=-L/usr/local/cuda/lib64
#This indicates additional directories where include files (".h files") may be found.
INCDIRS=-I/usr/local/cuda/include
#This is the command that will be used to remove file as part of a clean operation
RM= rm -rf

#You must modify this!!  TODO:
#OBJS should be all the object files that will be linked to form the executable
OBJS=main.o secondFile.o


#The following could be used in place of the default rule, replacing matrix_cuda with 
#the actual file names.  Would also put names of the user defined .h files that the
#CU files includes on the right
#matrix_cuda.o: matrix_cuda.cu
#     $(NVCC) $(CUDAFLAGS) -o matrix_cuda.o  matrix_cuda.cu

#This is the default rule for compiling cu files into corresponding object files
#Evidently, the include directories for cuda files are part of NVCC   
#-G generates debugging code for device, -g for the host.
#-O is the optimization level for host code
#-x cu specifies that the input file is to be treated as a cuda file, independent of the filename suffix
#-o specifies the name of the resulting object file
%.o: %.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	$(NVCC) -G -g -O0 --compile $(CUDAFLAGS) -x cu -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

#You must modify this!!  TODO:
# All Target.  The name on the right should be all the executables to be created (probably only one). 
all: testCUDA

# Tool invocations.  Provide a rule for each executable.  
# The right side of each rule lists all the object files the executable is comprised of. 
#Evidently, the library directory specifications for cuda files are part of NVCC
#You must modify this!!  TODO:
testCUDA: $(OBJS) 
	@echo 'Building target: $@'
	@echo 'Invoking: NVCC Linker'
	$(NVCC) --cudart static $(CUDAFLAGS) -link -o  "testCUDA" $(OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '


clean:
	-$(RM) testCUDA $(OBJS)
