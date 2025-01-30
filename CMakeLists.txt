cmake_minimum_required(VERSION 3.12)
project(cuda_hgemm LANGUAGES C CXX CUDA)

include_directories(${PROJECT_SOURCE_DIR}/src/common)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(CUDAToolkit REQUIRED)

set(CMAKE_CUDA_ARCHITECTURES 80)

set(CMAKE_CUDA_FLAGS "-Xcompiler -fopenmp --expt-relaxed-constexpr")
if(CMAKE_BUILD_TYPE MATCHES "Debug")
    set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS} -g -G")
else()
    set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS} --use_fast_math -O3")
endif()

add_executable(hgemm src/main.cu)
target_link_libraries(hgemm CUDA::cudart CUDA::cublas)

find_package(gflags REQUIRED)
target_link_libraries(hgemm ${GFLAGS_LIBRARIES})

find_package(OpenMP REQUIRED)
if(OpenMP_CXX_FOUND)
    target_link_libraries(hgemm OpenMP::OpenMP_CXX)
endif()

file(GLOB HGEMM_SRCS
    ${PROJECT_SOURCE_DIR}/src/*.cu
    ${PROJECT_SOURCE_DIR}/src/wmma/*.cu
    ${PROJECT_SOURCE_DIR}/src/mma/*.cu
)
target_sources(hgemm PRIVATE ${HGEMM_SRCS})

find_program(CCACHE_FOUND ccache)
set(CMAKE_VERBOSE_MAKEFILE ${HGEMM_VERBOSE_MAKEFILE})

install (TARGETS hgemm RUNTIME DESTINATION bin)