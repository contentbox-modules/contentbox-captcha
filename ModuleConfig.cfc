/**
* ********************************************************************************
* Copyright 2017 Ortus Solutions, Corp
* ********************************************************************************
* @author  Luis Majano
* Module configuration
*/
component {
    
        // Module Properties
        this.title 				= "ContentBox Clustered Captcha";
        this.author 			= "Ortus Solutions, Corp";
        this.webURL 			= "https://ortussolutions.com";
        this.description 		= "Generates a captcha image for your website's comment forms";
        this.version			= "1.0.0";
        // If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
        this.viewParentLookup 	= true;
        // If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
        this.layoutParentLookup = true;
        // Module Entry Point
        this.entryPoint			= "contentbox-captcha";

        /**
         * Configure Module
         */
        function configure(){
    
            // SES Routes
            routes = [
                // captcha delivery
			    { pattern="/", handler="home", action="index" },
                // Convention Route
                { pattern="/:handler/:action?" }
            ];
    
            // Custom Declared Interceptors
            interceptors = [
                { class="#moduleMapping#.interceptors.Captcha" }
            ];
        }
    
        /**
        * Fired when the module is registered and activated.
        */
        function onLoad(){
    
        }
    
        /**
        * Fired when the module is activated by ContentBox
        */
        function onActivate(){
    
        }
    
        /**
        * Fired when the module is unregistered and unloaded
        */
        function onUnload(){
    
        }
    
        /**
        * Fired when the module is deactivated by ContentBox
        */
        function onDeactivate(){
    
        }
    }