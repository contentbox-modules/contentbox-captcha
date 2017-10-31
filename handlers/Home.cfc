/**
 * This handler delivers cluster safe images
 */
component{
    
    // DI
    property name="captchaService"	inject="id:CaptchaService@contentbox-captcha";

    /**
	* Deliver Captcha
	*/
	function index( event, rc, prc ){
		// Setup Expire headers
		event.setHTTPHeader( name="expires", 		value="#GetHttpTimeString( now() )#" )
			.setHTTPHeader(  name="pragma", 		value="no-cache" )
            .setHTTPHeader(  name="cache-control",  value="no-cache, no-store, must-revalidate" );
            
		// Deliver Captcha
		var data 	= captchaService.display();
		var imgURL 	= arrayToList( reMatchNoCase( 'src="([^"]*)"', data ) );
		imgURL 		= replace( replace( imgURL, "src=", "" ) , '"', "", "all" );
        
        // deliver image to avoid cluster collisions
		getPageContext().forward( imgURL );
        
        // abort so CF does not choke.
		event.noRender();
	}

}