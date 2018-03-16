$(document).ready(function(){
    $("#stripe_connect")
    .bind("ajax:beforeSend", function(xhr){
        console.log("Before");
        $("#create_acc_loader").css("display", "block");
    })
    .bind("ajax:success", function(evt, xhr, status, data){
        console.log("Success");
        $("#create_acc_loader").css("display", "none");
        $(".agreement").css('display', 'block');
    })
    .bind("ajax:error", function(evt, xhr, status, data){
        console.log("Error");
        $("#create_acc_loader").css("display", "block");
        $(".stripe_result").html("Something went wrong, please try again..!");
    });  

    $("#register_account")
    .bind("ajax:beforeSend", function(xhr){
        console.log("Before");
        $("#agree_loader").css("display", "block");
    })
    .bind("ajax:success", function(evt, xhr, status, data){
        console.log("Success");
        $("#agree_loader").css("display", "none");
        $(".connect_to_stripe").css("display", "none");
        $(".required_info").css('display', 'block');

    })
    .bind("ajax:error", function(evt, xhr, status, data){
        console.log("Error");
        $("#agree_loader").css("display", "block");
        $(".agreement_result").html("Something went wrong, please try again..!");
    });        
});

    // let verify_details = (account_details) => {
    //     let stripe = Stripe('pk_test_hX4uRE9S0IrR043fAfqoWfSj');

    //     stripe.createToken('bank_account', {
    //         country: $(country).val(),
    //         currency: $(currency).val().toLowerCase(),
    //         routing_number: $(routing_number).val(),
    //         account_number: $(account_number).val(),
    //         account_holder_name: $(account_holder_name).val(),
    //         account_holder_type: $(acc_type).val(),
    //     }).then((result) => {
    //             if(result.error){
    //                 console.log(result.error);
    //                 $("#bank_fld_err").addClass("alert alert-danger");
    //                 $("#bank_fld_err").html("Please provide all the bank details properly.");
    //                 $("#additional_details").css("display", "none");                    
    //             }else{  
    //                 console.log(result.token);
    //                 $("#bank_fld_err").removeClass("alert alert-danger");
    //                 $("#bank_fld_err").html("");
    //                 $("#additional_details").css("display", "block");
    //                 $("#user_account_token").val(result.token.id);
    //                 $("#user_external_account").val(result.token.id);
    //             }
                
    //     });
    // }

let first_stage_parameters = () => {
    return([ "user_first_name", "user_last_name", "user_dob_1i",
    "user_dob_2i", "user_dob3i", "user_legal_entity_type"]);
}

var verify_params = (first_stage_parameters) => {
    if( $(user_first_name).val().trim().length == 0 || $(user_last_name).val().trim().length == 0 ||
        $(user_dob_1i).val().trim().length == 0 || $(user_dob_2i).val().trim().length == 0 || $(user_dob_3i).val().trim().length == 0 ||
        $(user_legal_entity_type).val().trim().length == 0 ){
            $("#reqd_fld_err").css("display", "block");
        }else{
            $("#reqd_fld_err").css("display", "none");
            $("#additional_info_frm").submit();
    }
}
    
   


