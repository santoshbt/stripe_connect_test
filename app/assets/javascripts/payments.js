$(document).ready(function(){
    var stripe = Stripe('pk_test_hX4uRE9S0IrR043fAfqoWfSj');
    var elements = stripe.elements();

    var style = {
        base: {
          color: '#32325d',
          lineHeight: '18px',
          fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
          fontSmoothing: 'antialiased',
          fontSize: '16px',
          '::placeholder': {
            color: '#aab7c4'
          }
        },
        invalid: {
          color: '#fa755a',
          iconColor: '#fa755a'
        }
      };
      
      // Create an instance of the card Element.
    var card = elements.create('card', {style: style});
    
    // Add an instance of the card Element into the `card-element` <div>.
    card.mount('#card-element');

    card.addEventListener('change', function(event) {
        var displayError = document.getElementById('card-errors');
        if (event.error) {
            displayError.textContent = event.error.message;
        } else {
            displayError.textContent = '';
        }
    });

    var form = document.getElementById('payment-form');
    form.addEventListener('submit', function(event) {
    event.preventDefault();

        stripe.createToken(card).then(function(result) {
            if (result.error) {
            // Inform the customer that there was an error.
            var errorElement = document.getElementById('card-errors');
            errorElement.textContent = result.error.message;
            } else {
            // Send the token to your server.
            stripeTokenHandler(result.token);
            }
        });
    });
});

function stripeTokenHandler(token) {
    // Insert the token ID into the form so it gets submitted to the server
    var form = document.getElementById('payment-form');
    var hiddenInput = document.createElement('input');
    hiddenInput.setAttribute('type', 'hidden');
    hiddenInput.setAttribute('name', 'stripeToken');
    hiddenInput.setAttribute('value', token.id);
    form.appendChild(hiddenInput);
  
    // Submit the form
    form.submit();
  }


// let verify_details = (account_details) => {
//     const stripe = Stripe('pk_test_hX4uRE9S0IrR043fAfqoWfSj');

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

// function payme(user){
//     console.log($(user).attr("id"));
//     let user_id = $(user).attr("id").substring(4);
//     let amount = $("#amount_"+user_id).val();

//     $.ajax({
//         url: "/payments/" + user_id + "/pay",
//         data: { amount: amount },
//         async: true,
//         dataType: 'script',
//         type: 'get',

//         success: function(resp) {
            
//         }    

//     })
// }