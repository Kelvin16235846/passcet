var  myselector="#__next > div.NewPageWithSidebarLayout_centeringDiv__rlXrY > div > section > div.NewPageWithSidebarLayout_scrollSection__hOt1S.NewPageWithSidebarLayout_startAtBottom__1Yhgy > div > div > footer > div > div.ChatMessageInputView_growWrap__mX_pX > textarea";
var q="hi";
var eleToSend="#__next > div.NewPageWithSidebarLayout_centeringDiv__rlXrY > div > section > div.NewPageWithSidebarLayout_scrollSection__hOt1S.NewPageWithSidebarLayout_startAtBottom__1Yhgy > div > div > footer > div > div.ChatMessageInputView_sendButtonWrapper__gyrGH > button > svg";
setInterval(function () {
    document.querySelector(myselector).value = q;
    var e = new Event("keydown");
    e.key = "Enter";
    e.keyCode = 13;
    var e0=document.querySelector(myselector);
    var e1=document.querySelector(eleToSend);
    e0.dispatchEvent(e)
    e1.dispatchEvent(e)
    e = new Event("keyup");
    e.key = "Enter";
    e.keyCode = 13;
    var e0=document.querySelector(myselector);
    var e1=document.querySelector(eleToSend);
    e0.dispatchEvent(e)
    e1.dispatchEvent(e)
}, 3000);
