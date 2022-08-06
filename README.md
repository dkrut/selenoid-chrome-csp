# selenoid-chrome-csp
Chrome with CryptoPro 5.0 for [Selenoid](https://github.com/aerokube/selenoid)  
For build this image, it is using base selenoid chrome image: [list of available chrome versions](https://hub.docker.com/r/selenoid/chrome/tags)  

__*cert*__ contains user's personal certificates and root certificate. Their validity period is 3 months, then it will be necessary to form new ones. It's generates here: http://testgost2012.cryptopro.ru/certsrv/  
__*dist*__ contains two packages: CryptoPro 5.0 and cades plugin for chrome. If you don't specify the activation key when building the dockerfile, then the trial version will be used, its validity period is 95 days. Packages are downloaded from:  
https://www.cryptopro.ru/products/csp/downloads  
https://www.cryptopro.ru/products/cades/downloads

To build image:  
`docker build -t selenoid/chrome_csp:<version> .`
