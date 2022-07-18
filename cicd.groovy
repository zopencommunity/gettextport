node('linux') 
{
        stage('Build') {
                build job: 'Port-Pipeline', parameters: [string(name: 'REPO', value: 'gettextport'), string(name: 'DESCRIPTION', 'gettext is an internationalization and localization system commonly used for writing multilingual programs on Unix-like computer operating systems.' )]
        }
}
