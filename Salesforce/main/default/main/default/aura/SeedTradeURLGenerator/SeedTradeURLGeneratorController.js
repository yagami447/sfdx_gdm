({

    doInit: function(component, event, helper) {
        console.log('Clicked!!');
        var action = component.get("c.fetchUserAccountId");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var accId = response.getReturnValue();
                console.log("ACC id FETCHED : ");
                console.log(accId);
                component.set("v.userInfo", accId);
                component.set("v.message", "Redireccionando a Seed Trade");
                let encryptedAccountID = window.btoa(accId);
                let url = 'https://seedtrade.com.br/app/login.php?sfid=' + encryptedAccountID;
                console.log('Url generada : ' + url);
                window.open(url);
            } else {
                component.set("v.message", "Error");
            }

        });
        $A.enqueueAction(action);
    }
})