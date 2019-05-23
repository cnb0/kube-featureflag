const fs = require('fs');
const ini = require("ini")

// Annotation watcher
// The annotations of the kubernetes pod are mounted as file.
//
const configurationFile  = process.env.CONFIG_FILE  || '/etc/podinfo/annotations';
fs.watchFile(configurationFile, (curr, prev) => {
    let config = ini.parse(fs.readFileSync(configurationFile, 'utf-8'))
    let implToUse = config.businessFeature;
    // parse the "implToUse" string and remove the "    e.g.
    // "function1" => function1
    if(implToUse){
        implToUse = implToUse.replace(/^"(.+(?="$))"$/, '$1');
    }
    switch(implToUse){
        case "implementation1":
            implementationCurrent = implementation1
            break;
        case "implementation2":
            implementationCurrent = implementation2
            break;
    }
    console.log(`business logic changed to [${implToUse}]`);
});


// Business Logic
//
let implementation1 = function(){console.log("Business function 1 called")}
let implementation2 = function(){console.log("Business function 2 called")}
let implementationCurrent = implementation1

function timerBusinessLogic(arg) {
    implementationCurrent()
}
setInterval(timerBusinessLogic, 1500, 'funky');
