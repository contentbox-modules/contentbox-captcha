/**
* ********************************************************************************
* Copyright 2017 Ortus Solutions, Corp
* ********************************************************************************
* @author Luis Majano
* Create captcha images using the ContentBox CacheStorages to allow for cluster distributions
*/
component accessors="true" singleton {
    
        // DI
        property name="cacheStorage" 		inject="cacheStorage@cbStorages";
    
        /**
         * Constructor
         */
        function init(){
            return this;
        }
    
        /**
         * I display the captcha and an error message, if appropriate
         */
        function display(
            length="4",
            text="#makeRandomString( arguments.length )#",
            width="200",
            height="50",
            message="Please enter the correct code shown in the graphic."
        ){
            var ret = "";
            setCaptchaCode( arguments.text );
    
            savecontent variable="ret" {
                cfimage( height=arguments.height, text=arguments.text, width=arguments.width, action="captcha" );
    
                if ( !isValidated() ){
                    writeOutput( "<br><span class=""cb_captchamessage"">#arguments.message#</span>" );
                }
            }
    
            /*  after it's decided whether to display the error message,
            clear the validation flag in case user just navigates to another page and comes back */
            setValidated( true );
            return ret;
        }
    
        /**
         * I validate the passed in against the captcha code
         */
        function validate( required code ){
            if ( hash( lcase( arguments.code ), "SHA" ) == getCaptchaCode() ){
                clearCaptcha();
                //  delete the captcha struct
                return true;
            } else {
                setValidated( false );
                return isValidated();
            }
        }
    
        function setCaptchaCode( required captchastring ){
            getCaptchaStorage().captchaCode = hash( lcase( arguments.captchastring ), "SHA" );
        }
    
        function getCaptchaCode(){
            return getCaptchaStorage().captchaCode;
        }
    
        // ---------------------------------------- PRIVATE ----------------------------------------
    
        private function getCaptchaStorage(){
            var captcha = { captchaCode = "", validated = true };
    
            if ( !variables.cacheStorage.exists( "cb_captcha" ) ){
                variables.cacheStorage.setVar( "cb_captcha", captcha );
            }
    
            return variables.cacheStorage.getVar( "cb_captcha" );
        }
    
        private function setValidated( required validated ){
            getCaptchaStorage().validated = arguments.validated;
        }
    
        private function isValidated(){
            return getCaptchaStorage().validated;
        }
    
        private function clearCaptcha(){
            variables.cacheStorage.deleteVar( "cb_captcha" );
        }
    
        private function makeRandomString( length="4" ){
            var min = arguments.length - 1;
            var max = arguments.length + 1;
            /*  Function ripped of from Raymond Camden
            ( http://www.coldfusionjedi.com/index.cfm/2008/3/29/Quick-and-Dirty-ColdFusion-8-CAPTCHA-Guide )
            */
            var chars = "23456789ABCDEFGHJKMNPQRSabcdefghjkmnpqrs";
            var captchalength = randRange( min, max );
            var result = "";
            var i = "";
            var char = "";
    
            for( i = 1; i <= captchalength; i++ ){
                char = mid( chars, randRange( 1, len( chars ) ), 1 );
                result &= char;
            }
    
            return result;
        }
    }