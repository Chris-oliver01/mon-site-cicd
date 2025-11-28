pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Test (none)') {
      steps {
        echo "Pas de tests pour cet exercice"
      }
    }

    stage('Deploy to nginx') {
      steps {
        // on utilise rsync via sudo pour copier le contenu du workspace vers /var/www/html/site
        sh '''
          echo "Deploying to /var/www/html/site"
          sudo rsync -av --delete --exclude=.git ./ /var/www/html/site/
          sudo chown -R www-data:www-data /var/www/html/site
        '''
      }
    }
  }
}
