function sendImpressionEvent(site, title)
{
    ga('send', 'event', 'Suggest Job Impression', 'Job-Impression | ' + site, 'Job-Impression | ' + site + ' | ' + title, 1);
}

function sendClickEvent(site, title)
{
    ga('send', 'event', 'Suggest Job Click', 'Job-Click | ' + site, 'Job-Click | ' + site + ' | ' + title, 1);
}

function sendClickRegisterFacebookEvent()
{
    ga('send', 'event', 'Signup', 'Register Facebook', 1);
}

function sendClickRegisterEmailEvent()
{
    ga('send', 'event', 'Signup', 'Register Email', 1);
}
