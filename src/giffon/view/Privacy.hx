package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import thx.Decimal;
import js.moment.Moment;
using DateTools;
using giffon.db.WishProgress.WishProgressTools;

class Privacy extends Page {
    override function title() return 'Privacy Policy - Giffon';
    override function path() return "privacy";
    override function render() return super.render();

    override function bodyClasses() return super.bodyClasses().concat(["page-privacy"]);

    override function bodyContent() return jsx('
        <div className="container">
            <h1>Giffon Privacy Policy</h1>

            <p>This Privacy Policy describes how your personal information is collected, used, and shared when you visit https://giffon.io (the “Site”).</p>

            <h2>PERSONAL INFORMATION WE COLLECT</h2>

            <p>When you visit the Site, we automatically collect certain information about your device, including information about your web browser, IP address, time zone, and some of the cookies that are installed on your device. Additionally, as you browse the Site, we collect information about the individual web pages or products that you view, what websites or search terms referred you to the Site, and information about how you interact with the Site. We refer to this automatically-collected information as “Device Information.”</p>

            <p>We collect Device Information using the following technologies:</p>

            <p>- “Cookies” are data files that are placed on your device or computer and often include an anonymous unique identifier. For more information about cookies, and how to disable cookies, visit http://www.allaboutcookies.org.</p>
            <p>- “Log files” track actions occurring on the Site, and collect data including your IP address, browser type, Internet service provider, referring/exit pages, and date/time stamps.</p>
            <p>- “Web beacons,” “tags,” and “pixels” are electronic files used to record information about how you browse the Site.</p>

            <p>Additionally when you make a purchase or attempt to make a purchase through the Site, we collect certain information from you, including your name, billing address, shipping address, payment information (including credit card numbers and others), email address, and phone number.  We refer to this information as “Order Information.”</p>

            <p>
                When you connect your Giffon account to YouTube, we use <a href="https://developers.google.com/youtube/terms/developer-policies#definition-youtube-api-services" target="_blank" rel="noopener">YouTube API Services</a> to obtain certain YouTube data from you, including your YouTube user name and profile link address. 
                You are subject to the <a href="http://www.google.com/policies/privacy" target="_blank" rel="noopener">Google Privacy Policy</a>. 
                You can revoke Giffon\'s access to your data via the <a href="https://security.google.com/settings/security/permissions" target="_blank" rel="noopener">Google security settings page</a>.
            </p>

            <p>When we talk about “Personal Information” in this Privacy Policy, we are talking both about Device Information and Order Information.</p>

            <h2>HOW DO WE USE YOUR PERSONAL INFORMATION?</h2>

            <p>We use the Order Information that we collect generally to fulfill any orders placed through the Site (including processing your payment information, arranging for shipping, and providing you with invoices and/or order confirmations).  Additionally, we use this Order Information to:</p>
            <p>Communicate with you;</p>
            <p>Screen our orders for potential risk or fraud; and</p>
            <p>When in line with the preferences you have shared with us, provide you with information or advertising relating to our products or services.</p>

            <p>We use the Device Information that we collect to help us screen for potential risk and fraud (in particular, your IP address), and more generally to improve and optimize our Site (for example, by generating analytics about how our customers browse and interact with the Site, and to assess the success of our marketing and advertising campaigns).</p>

            <p>We use the collected YouTube data to verify your YouTube identidy, allows you to optionally display a badge about your YouTube profile in your public Giffon profile page.</p>

            <h2>SHARING YOUR PERSONAL INFORMATION</h2>

            <p>We share your Personal Information with third parties to help us use your Personal Information, as described above.  For example, we use Google Analytics to help us understand how our customers use the Site--you can read more about how Google uses your Personal Information here:  https://www.google.com/intl/en/policies/privacy/.  You can also opt-out of Google Analytics here:  https://tools.google.com/dlpage/gaoptout.</p>

            <p>We do not share your YouTube data with any external parties.</p>

            <p>Finally, we may also share your Personal Information to comply with applicable laws and regulations, to respond to a subpoena, search warrant or other lawful request for information we receive, or to otherwise protect our rights.</p>

            <h2>BEHAVIOURAL ADVERTISING</h2>
            <p>As described above, we use your Personal Information to provide you with targeted advertisements or marketing communications we believe may be of interest to you.  For more information about how targeted advertising works, you can visit the Network Advertising Initiative’s (“NAI”) educational page at http://www.networkadvertising.org/understanding-online-advertising/how-does-it-work.</p>

            <p>You can opt out of targeted advertising by:</p>
            <p>FACEBOOK - https://www.facebook.com/settings/?tab=ads</p>
            <p>GOOGLE - https://www.google.com/settings/ads/anonymous</p>

            <p>Additionally, you can opt out of some of these services by visiting the Digital Advertising Alliance’s opt-out portal at:  http://optout.aboutads.info/.</p>

            <h2>DO NOT TRACK</h2>
            <p>Please note that we do not alter our Site’s data collection and use practices when we see a Do Not Track signal from your browser.</p>

            <h2>YOUR RIGHTS</h2>
            <p>If you are a European resident, you have the right to access personal information we hold about you and to ask that your personal information be corrected, updated, or deleted. If you would like to exercise this right, please contact us through the contact information below.</p>

            <p>Additionally, if you are a European resident we note that we are processing your information in order to fulfill contracts we might have with you (for example if you make an order through the Site), or otherwise to pursue our legitimate business interests listed above.  Additionally, please note that your information will be transferred outside of Europe, including to Canada and the United States.</p>

            <h2>DATA RETENTION</h2>
            <p>When you place an order through the Site, we will maintain your Order Information for our records unless and until you ask us to delete this information.</p>

            <h2>CHANGES</h2>
            <p>We may update this privacy policy from time to time in order to reflect, for example, changes to our practices or for other operational, legal or regulatory reasons.</p>

            <h2>CONTACT US</h2>
            <p>For more information about our privacy practices, if you have questions, or if you would like to make a complaint, please contact us by e-mail at admin@giffon.io or by mail using the details provided below:</p>

            <p>G18, Man Lee House, Tai Hang Sai Est., Kowloon, Hong Kong</p>
        </div>
    ');
}