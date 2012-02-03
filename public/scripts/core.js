function validateBasicSearch()
{
    if(document.getElementById('searchbox').value == '')
    {
        alert('The query cannot be empty');
        return false;
    }
    else
        return true;
}