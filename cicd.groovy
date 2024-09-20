node('linux') 
{
        stage ('Poll') {
                checkout([
                        $class: 'GitSCM',
                        branches: [[name: '*/main']],
                        doGenerateSubmoduleConfigurations: false,
                        extensions: [],
                        userRemoteConfigs: [[url: 'https://github.com/zopencommunity/gettextport.git']]])
        }

        stage('Build') {
                build job: 'Port-Pipeline', parameters: [string(name: 'PORT_GITHUB_REPO', value: 'https://github.com/zopencommunity/gettextport.git'), string(name: 'PORT_DESCRIPTION', value: 'gettext is an internationalization and localization system commonly used for writing multilingual programs on Unix-like computer operating systems.' ), string(name: 'NODE_LABEL', value: "v2r4") ]
        }
}
