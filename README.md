# selenoid-chrome-csp
Chrome with CryptoPro 5.0 for [Selenoid](https://github.com/aerokube/selenoid)

__*cert*__ contains user's personal certificates and root certificate. Their validity period is 3 months, then it will be necessary to form new ones. It's generates here: http://testgost2012.cryptopro.ru/certsrv/  
__*dist*__ contains two packages: CryptoPro 5.0 and cades plugin for chrome. If you don't specify the activation key when building the dockerfile, then the trial version will be used, its validity period is 95 days. Packages are downloaded from:  
https://www.cryptopro.ru/products/csp/downloads  
https://www.cryptopro.ru/products/cades/downloads

Before building the image, check the chrome version in the dockerfile: [list of available versions](https://hub.docker.com/r/selenoid/chrome/tags)  
Also check the name of files with certificates, the password for personal certificates and the CryptoPro activation key (if you have)

To build image:  
`docker build -t selenoid/chrome_csp:<version> .`
