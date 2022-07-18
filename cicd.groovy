node('linux') 
{
        stage('Build') {
                build job: 'Port-Pipeline', parameters: [string(name: 'REPO', value: 'gettextport'), string(name: 'DESCRIPTION', 'gettextport' )]
        }
}
