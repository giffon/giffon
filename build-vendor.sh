browserify \
    -r react \
    -r react-dom \
    -r formik \
    -r react-datepicker \
    -r validator \
    -r react-stripe-elements \
    -r react-clipboard.js \
    -r react-giphy-component \
    -r react-switch \
    -r @material-ui/core/Radio \
    -r @material-ui/core/RadioGroup \
    -r @material-ui/core/FormControlLabel \
    -r @material-ui/core/FormControl \
    -r @material-ui/core/FormLabel \
    -r react-paypal-button-v2 \
    -r formik-material-ui \
    -r react-block-ui \
    -g [ envify --NODE_ENV production ] \
    -g uglifyify \
    | uglifyjs --compress --mangle \
    > www/js/vendor.js
