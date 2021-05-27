# macOS corss compiler environment docker builder

* Dockerfile , changed repositories to mirrors in China. 
       
* Build docker
    1.docker build --progress=plain -t c6supper/venus-builder -f Dockerfile ./ 
    
* Build release docker
    1. change the version
    2. ../../build-env/build.sh c6supper venus-builder release
