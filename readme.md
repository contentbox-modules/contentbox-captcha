<img src="https://www.contentboxcms.org/__media/ContentBox_300.png" class="img-thumbnail"/>

# ContentBox Clustered Captcha

This module will add Captcha Security to your comment forms that can be distributed in a cluster as it leverages the `CacheStorages` module.

## Installation

Just use CommandBox: `box install contentbox-captcha`, then visit your ContentBox administrator and activate the module in the **Modules** section.

## Usage

This module will automatically add Captcha security to your comment forms.  However, you can also leverage it to add it to any form.

### Displaying the Captcha

You can display the captcha by using the following code:

```
<!-- Display Captch using /contentbox-captcha entry point -->
<img src='#event.buildLink( 'contentbox-captcha' )#' />

<!-- Field For Input -->
#HTMLHelper.textField(
    name			= "captchacode",
    label			= "Enter the security code shown above:",
    required		= "required",
    class			= "form-control",
    groupWrapper	= "div class=form-group",
    size			= "50"
)#
```

### Validating the Captcha

You will need access to the captcha service which is registered in WireBox as `CaptchaService@contentbox-captcha`.  You can inject it in your handlers like so:

```
property name="captchaService"	inject="id:CaptchaService@contentbox-captcha";
```

You can then in the receiving action validate it using something like this:

```
if( !captchaService.validate( rc.captchacode ){
    // Captcha is invalid.
}
```

## License
Apache License, Version 2.0.

## Important Links
- https://github.com/contentbox-modules/contentbox-captcha

## System Requirements
- Lucee 4.5+
- ColdFusion 11+


---
 
### THE DAILY BREAD
 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12