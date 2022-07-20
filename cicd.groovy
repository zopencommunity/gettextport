node('linux') 
{
        stage ('Poll') {
                checkout([
                        $class: 'GitSCM',
                        branches: [[name: '*/main']],
                        doGenerateSubmoduleConfigurations: false,
                        extensions: [],
                        userRemoteConfigs: [[url: 'https://github.com/ZOSOpenTools/gettextport.git']]])
        }

        stage('Build') {
                build job: 'Port-Pipeline', parameters: [string(name: 'REPO', value: 'gettextport'), string(name: 'DESCRIPTION', value: 'gettext is an internationalization and localization system commonly used for writing multilingual programs on Unix-like computer operating systems.' )]
        }
}
