# MPGram Web

## Still in development. Container doesn't work properly! 

### This fork cuts docker-compose.yaml. A single container is created where all the necessary applications run. This is done to provide the ability to deploy a container on [Render](https://render.com/) for free.

### You can also deploy this container both on your server and on any other hosting.

### IMPORTANT! Follow the instructions regarding the telegram API, otherwise the operation of the container is not guaranteed.

### No changes were made to the remaining files.

Lightweight Telegram web client based on MadelineProto.

Test instance is available at <a href="https://mp.nnchan.ru/">https://mp.nnchan.ru</a> (not guaranteed to run a stable version).

_It is highly recommended to run your own instance (read on)._

## Setup

- Generate your own API id by creating a Telegram app at <a href="https://my.telegram.org/apps">https://my.telegram.org/apps</a> 
- Create `api_value.php` from the `api_values.php.example` using the `api_id` and `api_hash` you generated
- Create `config.php` from the `config.php.example` (for Docker container deployment you shouldn't do this)

## Deployment

### Docker

On your own server:

1. ```bash
   git clone https://github.com/Elux414/mpgram-for-render
   ```
2. ```bash
   cd mpgram-for-render
   ```
3. ```bash
   docker build -t mpgram .
   ```
4. ```bash
   docker run --name=mpgram -itd mpgram
   ```
5. Access the web interface: http://ip-address

On Render:

Since you need to make changes to api_values.php.example, I would advise you to copy this repository as a fork, so it will be more convenient for you to make changes and deploy the container on Render or other hosting that supports authorization via Github. But Render provides the ability to import an image from Docker Hub, so you can try to build the image according to the instructions above, upload the image to Docker Hub and deploy this image to Render.

1. Create a Web Service on Render
2. Connect your repository (you should link your Render and Github accounts)
3. Runtime enviroment shoud be Docker
4. Instance type - Free
5. Region - EU or any other you like
6. Click "Create Web Service"
7. After building and deploying you can access web site via URL that is in the top left corner of the Render interface

All should be working now.

### Manual deployment

- Deny access to sessions folder (`s/` by default, see in `config.php`) and `MadelineProto.log`
- Install required php extensions: `gd`, `mbstring`, `xml`, `json`, `fileinfo`, `gmp`, `iconv`, `ffi`
- Download and set [browscap](https://browscap.org/) database in `php.ini` to get better logged in device names
- Install Composer v2+
- Install MadelineProto and its dependencies with `composer update`
- Make a background script that restarts php service at least every hour
- For more details on installing MadelineProto <a href="https://docs.madelineproto.xyz/docs/REQUIREMENTS.html">see here</a>

## Tested browsers

Fully supported:

- Internet Explorer 6.0 and above
- Opera 9.0 and above
- Nokia Browser for Symbian (S60v3 FP1 and above)
- S40 6th Edition
- Mozilla Firefox 2.0
- WebPositive
- Opera Mobile 12
- All modern browsers (Chrome, Safari, etc)

Partially supported (Auto update doesn't work and/or no auto scroll):

- Internet Explorer 3.0-5.0
- Opera Mini (All versions)
- S40 5th Edition or older
- Internet Explorer Mobile (?)

Not supported
- Internet Explorer 2 and older

