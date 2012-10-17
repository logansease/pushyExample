
<div class="well">
<h1>Getting Started - iOS Setup</h1>
<h3>Step 1-  Download the iOS API Sample app</h3>
<p><%= link_to 'Version 1.0', 'https://github.com/logansease/pushyExample' %></p>

<h3>Step 2-  Extract and open the sample app</h3>
<h3>Step 3-  Copy Dependant Libraries</h3>
<p>Drag and drop the following folders from the sample app into your project</p>
<ul>
  <li>ASIHTTP</li>
</ul>
<h3>Step 4-  Copy Pushy API Files</h3>
<p>Drag and drop the files in the Pushy folder from the sample project.</p>
<h3>Step 5-  Link Required Frameworks</h3>
<p>Add the following frameworks to your project</p>
<ul>
  <li>MobileCoreServices</li>
  <li>CFNetwork</li>
  <li>libz.dylib</li>
  <li>SystemConfiguration</li>
</ul>

<h3>Step 6- Set your project up for Push Notifications</h3>
    <p>Go to the Apple iOS Provisioning Portal, configure your app for Push Notifications and download your push certificates.</p>
<h3>Step 7- Convert your certificates  </h3>
  <p>Go to the folder where you saved your certificates in step 6. Run the following commands on both the
  Development and the Production certificate. Ensure that you name them appropriately. In the commands below,
  replace aps_push_certificate_DEV with the names of the certificates you saved in step 6. The output file name 'outputName_DEV_cert'
  can be replaced with any name, just so you can remember which is development and which is production.</p>
  <div class="code-box">
  <pre><code>
  $ openssl x509 -in aps_push_certificate_DEV.cer -inform der
      -out outputName_DEV_cert.pem</p>
  $ openssl pkcs12 -nocerts -out outputName_DEV_cert.pem -in outputName_DEV_cert.p12</p>
  </code></pre>
  </div>

<h3>Step 8-  Set up Pushy API App</h3>
<p>Register at pushyapi.com. Create a new app.</p>
<p>Copy and paste the contents of the dev/prod .pem files generated in step 7 into the dev / prod certificate fields.</p>
<p>In your project, open PushyNotificationService.h and add the app ID and secret Key for your app.</p>

<h3>Step 9- Add Pushy Registration code to your AppDelegate</h3>
<p>
  <div class="code-box">
  <pre><code>
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        ...
        NSLog(@"Registering for push notifications...");
        [[UIApplication sharedApplication]
            registerForRemoteNotificationTypes:
            (UIRemoteNotificationType)
            (UIRemoteNotificationTypeBadge |
            UIRemoteNotificationTypeSound |
            UIRemoteNotificationTypeAlert)];
    }
    - (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
        NSString *str = [NSString stringWithFormat:@"Device Token=%@",deviceToken];
        [[PushNotificationService sharedService] saveNewDevice:deviceToken];
    }
    </code></pre>
  </div>
</p>

<h3>You're ready to go!</h3>

</div>

<div class="well">
  <h1>Getting Started - Use it</h1>
  <p>Log into PushyAPI.com</p>
  <p>Select your App, and press 'Push Notifications'.</p>
  <p>Here you can view how many devices have registered to receive push notifications from within your app.</p>
  <p>Press on 'Send notification', and fill out a simple form with the Info you'd like in your Notification and press send.</p>

  <h3>That's it!</h3>
  <p>All users of your app that have registered will receive the push notification to their device. It's that easy!</p>

</div>