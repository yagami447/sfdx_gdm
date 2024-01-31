pipeline {
    agent any

    stages {
        stage('Instalación Node.js y npm') {
            steps {
                script {
                    echo 'Versión de Node.js:'
                    sh 'node --version'
                    echo 'Versión de npm:'
                    sh 'npm --version'
                }
            }
        }

        stage('Instalación Vlocity Build Tool') {
            steps {
                script {
                    echo 'Versión de Vlocity Build Tool:'
                    sh 'vlocity --version'
                }
            }
        }

        stage('Instalación Salesforce CLI') {
            steps {
                script {
                    echo 'Versión de Salesforce CLI:'
                    sh 'sfdx --version'
                }
            }
        }

        stage('Instalación Git') {
            steps {
                script {
                    echo 'Versión de Git:'
                    sh 'git --version'
                }
            }
        }

        stage('Instalación Python y pip') {
            steps {
                script {
                    echo 'Versión de Python:'
                    sh 'python3 --version'
                    echo 'Versión de pip:'
                    sh 'pip3 --version'
                }
            }
        }
    }
}
