// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function remove_fields (link)
{
    $(link).previous("input[type=hidden]").value = "1";
    $(link).up(".fields").hide();

}

function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g")
    $(link).up().insert({
        before: content.replace(regexp, new_id)
    });
}

function openlogout(){
    my_window = window.open('https://www.google.com/accounts/Logout',"mywindow",
        "status=100,width=100,height=100,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no");
    my_window.blur();
    setTimeout(closepopup,7000);
    
}
function closepopup(){
    if(false == my_window.closed){
        my_window.close();
        window.location = "http://localhost:3000/session/client_logout";
    }
}

function not_logged_in_to_gmail(){
    window.location = "http://localhost:3000/session/client_logout";
}