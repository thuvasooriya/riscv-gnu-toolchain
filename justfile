# replace the prefix with your own

default: clean config make_tc

config:
    #!/bin/bash
    export M4=$(which m4)
    ./configure --prefix=/Users/tony/riscv --enable-multilib --with-cmodel=medany --with-languages=c,c++,fortran

make_tc:
    #!/bin/bash
    export M4=$(which m4)
    make -j$(nproc)

clean:
    make clean
