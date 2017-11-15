/**
* ********************************************************************************
* Copyright 2017 Ortus Solutions, Corp
* ********************************************************************************
* @author  Luis Majano
* Captcha interceptor to insert the captcha image and validate the captcha code on comment post
*/
component extends="coldbox.system.Interceptor" {
    
        // DI
        property name="captchaService"	inject="id:CaptchaService@contentbox-captcha";
        property name="HTMLHelper"		inject="HTMLHelper@coldbox";
    
        /**
        * Configure interceptor
        */
        function configure(){
            return this;
        }
    
        /**
        * Add captcha to comment form
        */
        function cbui_postCommentForm( event, interceptData, buffer, rc, prc ){
            buffer.append("
                <img src='#event.buildLink( 'contentbox-captcha' )#' />
                
                #HTMLHelper.textField(
                    name			= "captchacode",
                    label			= "Enter the security code shown above:",
                    required		= "required",
                    class			= "form-control",
                    groupWrapper	= "div class=form-group",
                    size			= "50"
                )#
            ");
        }
    
        /**
        * intercept comment post to validate captcha
        */
        function cbui_preCommentPost( event, interceptData, buffer, rc, prc ){
            // Only show if not logged in.
            if( prc.oCurrentAuthor.isLoggedIn() ){
                return;
            }

            param name="rc.captchacode" default="";

            if( !captchaService.validate( rc.captchacode ) ){
                arrayAppend( arguments.interceptData.commentErrors, "Invalid security code. Please try again." );
            }
        }
    }