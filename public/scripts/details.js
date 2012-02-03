function changeToTextFieldTitle(sp, id, ce)
{
    if(!sp || typeof sp == "undefined")
        return;
    if(!id || typeof id == "undefined" || id == null || id == "")
        return;
    var txt = sp.innerHTML+"";
    txt = myEscape2(txt);
    var mt = txt.match('<input');
    if(!(!mt || typeof mt == "undefined" || mt == null))
        return;
    var onblurstr = "this.parentNode.innerHTML = this.value+''; if(this.value != '"+myEscape(txt)+"') { showSaveSpan(); document.getElementById('crtmod').innerHTML = 'Created: 29/9/2011 3:20 pm&nbsp;&nbsp;&nbsp;&nbsp;Modified: 6/10/2011 2:45 pm'; }";
    if(ce)
        onblurstr = "if(this.value != '') { "+onblurstr+" } else { this.parentNode.innerHTML = '"+myEscape(txt)+"'; }";
    sp.innerHTML = '<input type="text" style="font-size:40px;" size="50" id="'+id+'" value="'+txt+'" onblur="'+onblurstr+'" />';
    document.getElementById(id+"").focus();
}
function changeToTextField(sp, id, ce)
{
    if(!sp || typeof sp == "undefined")
        return;
    if(!id || typeof id == "undefined" || id == null || id == "")
        return;
    var txt = sp.innerHTML+"";
    txt = myEscape2(txt);
    var mt = txt.match('<input');
    if(!(!mt || typeof mt == "undefined" || mt == null))
        return;
    var onblurstr = "this.parentNode.innerHTML = this.value+''; if(this.value != '"+myEscape(txt)+"') { showSaveSpan(); document.getElementById('crtmod').innerHTML = 'Created: 29/9/2011 3:20 pm&nbsp;&nbsp;&nbsp;&nbsp;Modified: 6/10/2011 2:45 pm'; }";
    if(ce)
        onblurstr = "if(this.value != '') { "+onblurstr+" } else { this.parentNode.innerHTML = '"+myEscape(txt)+"'; }";
    sp.innerHTML = '<input type="text" style="font-size:20px;" size="50" id="'+id+'" value="'+txt+'" onblur="'+onblurstr+'" />';
    document.getElementById(id+"").focus();
}
function changeToTextArea(sp, id, ce)
{
    if(!sp || typeof sp == "undefined")
        return;
    if(!id || typeof id == "undefined" || id == null || id == "")
        return;
    var txt = sp.innerHTML+"";
    txt = myEscape2(txt);
    var mt = txt.match('<textarea');
    if(!(!mt || typeof mt == "undefined" || mt == null))
        return;
    var onblurstr = "this.parentNode.innerHTML = (this.value+'').replace(/\\n/g, '<br />'); if(this.value != '"+myEscape(txt)+"') { showSaveSpan(); document.getElementById('crtmod').innerHTML = 'Created: 29/9/2011 3:20 pm&nbsp;&nbsp;&nbsp;&nbsp;Modified: 6/10/2011 2:45 pm'; }";
    if(ce)
        onblurstr = "if(this.value != '') { "+onblurstr+" } else { this.parentNode.innerHTML = '"+myEscape(txt)+"'; }";
    sp.innerHTML = '<textarea rows="5" cols="50" style="font-size:20px;" id="'+id+'" onblur="'+onblurstr+'">'+txt.replace(/<br \/>/g, '\n').replace(/<br>/g, '\n')+'</textarea>';
    document.getElementById(id+"").focus();
}
function changeToAutocompleteTextField(sp, lst, id, ce)
{
    if(!sp || typeof sp == "undefined")
        return;
    if(!lst || typeof lst == "undefined" || lst.length <= 0)
        return;
    if(!id || typeof id == "undefined" || id == null || id == "")
        return;
    var txt = sp.innerHTML+"";
    txt = myEscape2(txt);
    var mt = txt.match('<input');
    if(!(!mt || typeof mt == "undefined" || mt == null))
        return;
    var onblurstr = "this.parentNode.innerHTML = this.value+''; if(this.value != '"+myEscape(txt)+"') { showSaveSpan(); document.getElementById('crtmod').innerHTML = 'Created: 29/9/2011 3:20 pm&nbsp;&nbsp;&nbsp;&nbsp;Modified: 6/10/2011 2:45 pm'; }";
    if(ce)
        onblurstr = "if(this.value != '') { "+onblurstr+" } else { this.parentNode.innerHTML = '"+myEscape(txt)+"'; }";
    sp.innerHTML = '<input type="text" style="font-size:20px;" size="50" id="'+id+'" value="'+txt+'" onblur="'+onblurstr+'" />';
    setupAutocomplete(id+"", lst);
    document.getElementById(id+"").focus();
}
function myEscape(str)
{
    str = str.replace(/\\/g, '\\\\');
    str = str.replace(/\'/g, '\\\'');
    str = str.replace(/\"/g, '\\"');
    str = str.replace(/&apos;/g, '\\\'');
    str = str.replace(/\0/g, '\\0');
    return str;
}
function myEscape2(str)
{
    str = str.replace(/\'/g, '&apos;');
    str = str.replace(/\"/g, '&quot;');
    return str;
}

function showSaveSpan()
{
    $("#changedspan").show().delay(1000).fadeOut(2000);
}