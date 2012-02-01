var validator;
$(function()
{
   //setupAutocomplete("category", ["External Hard Drive", "Internal Hard Drive", "RAM", "Uncategorized"]);
   validator = new ValidationManager();
   validator.interpretForm(document.getElementById("mainform"));
   addField();
});
var fldind = 0;

var fncfail = function(params)
{
    alert("You are missing the required "+params.Item.id+" field.  Please fill it in before submitting.");
}

var bdata = Array();

function addField()
{
    var cnt = document.getElementById("cont");
    if(!cnt || typeof cnt == "undefined")
        return;
    var tmpin = document.createElement("input");
    cnt.appendChild(tmpin);
    tmpin.type = "text";
    tmpin.id = "fld"+fldind;
    tmpin.style.fontSize = "20px";
    bdata[tmpin.id+""] = false;
    tmpin.onblur = function()
    {
        if(this.value != "" && !bdata[this.id+""])
            addField();
        bdata[this.id+""] = true;
    }
    var tmpsp = document.createElement("span");
    cnt.appendChild(tmpsp);
    tmpsp.innerHTML = "&nbsp;&nbsp;:&nbsp;&nbsp;";
    tmpsp.style.fontSize = "20px;"
    tmpin = document.createElement("input");
    cnt.appendChild(tmpin);
    tmpin.type = "text";
    tmpin.style.fontSize = "20px";
    cnt.appendChild(document.createElement("br"));
    cnt.appendChild(document.createElement("br"));
    setupAutocomplete("fld"+fldind, keylist);
    fldind++;
}