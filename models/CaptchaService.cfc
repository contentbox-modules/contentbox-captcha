/**
* ********************************************************************************
* Copyright 2017 Ortus Solutions, Corp
* ********************************************************************************
* @author Luis Majano
*
* Create captcha images using the CacheStorages to allow for cluster distributions
*/
component accessors="true" singleton {
    
        // DI
        property name="cacheStorage" 		inject="cacheStorage@cbStorages";

        // Static Constructs
        variables.CACHE_KEY = "cb_captcha";
    
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
         * Validate the incoming code string
         * 
         * @code The code to validate
         */
        boolean function validate( required code ){
            if ( hash( lcase( arguments.code ), "SHA" ) == getCaptchaCode() ){
                clearCaptcha();
                //  delete the captcha struct
                return true;
            } else {
                setValidated( false );
                return false;
            }
        }
        
        /**
         * Store the captcha code in storage
         * 
         * @captchaString The string to store
         */
        function setCaptchaCode( required captchaString ){
            var storage = getCaptchaStorage();
            storage.captchaCode = hash( lcase( arguments.captchaString ), "SHA" );
            variables.cacheStorage.setVar( variables.CACHE_KEY, storage );
            return this;
        }
        
        /**
         * Get the current setup captcha code
         */
        function getCaptchaCode(){
            return getCaptchaStorage().captchaCode;
        }
    
        // ---------------------------------------- PRIVATE ----------------------------------------
        
        /**
         * Return the captcha storage from storage
         * 
         * @return { captchaCode:string, validated:boolean }
         */
        private struct function getCaptchaStorage(){
            var defaults = { captchaCode = "", validated = true };
            return variables.cacheStorage.getVar( variables.CACHE_KEY, defaults );
        }
        
        /**
         * Set validation of code in storage
         *
         * @validated Flag
         * 
         * @return CaptchaService
         */
        private function setValidated( required boolean validated ){
            var storage = getCaptchaStorage();
            storage.validated = arguments.validated;
            // Store again in cache
            variables.cacheStorage.setVar( variables.CACHE_KEY, storage );
            return this;
        }
        
        /**
         * Is the code validated?
         */
        private boolean function isValidated(){
            return getCaptchaStorage().validated;
        }
        
        /**
         * Clear captcha indicator from cache storage
         * 
         * @return CaptchaService
         */
        private function clearCaptcha(){
            variables.cacheStorage.deleteVar( variables.CACHE_KEY );
            return this;
        }
    
        /**
         * Make a random string
         *
         * @length The length of the string
         */
        private function makeRandomString( length="4" ){
            var min = arguments.length - 1;
            var max = arguments.length + 1;
            /*  Function ripped of from Raymond Camden
            ( http://www.coldfusionjedi.com/index.cfm/2008/3/29/Quick-and-Dirty-ColdFusion-8-CAPTCHA-Guide )
            */
            var chars         = "23456789ABCDEFGHJKMNPQRSabcdefghjkmnpqrs";
            var captchalength = randRange( min, max );
            var result        = "";
            var char          = "";
    
            for( var i = 1; i <= captchalength; i++ ){
                char = mid( chars, randRange( 1, len( chars ) ), 1 );
                result &= char;
            }
    
            return result;
        }
    }