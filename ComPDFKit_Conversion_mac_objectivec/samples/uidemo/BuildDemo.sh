mkdir -p build && cd build
arch=$(uname -m) 
if [ "$arch" = "x86_64" ]; then
    cmake .. -DCMAKE_SYSTEM_PROCESSOR="x86_64"
elif [ "$arch" = "arm64" ]; then
    cmake .. -DCMAKE_SYSTEM_PROCESSOR="arm"
else
    exit 1
fi

make -j10
