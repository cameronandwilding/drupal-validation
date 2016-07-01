CONTENTS OF THIS FILE
---------------------

 * Introduction
 * Requirements
 * Installation
 * Configuration
 * Running
 * Maintainers

Introduction
------------

This script allows you to automatically check the code validation of a Drupal installation
using known tools such code sniffer, copy+paste validator or mess detector.

Requirements
------------

This doesn't need to be installed as a Drupal module. Can be placed anywhere in your system.

Composer is necessary in order to download the dependencies.
 * [Composer](https://getcomposer.org/)
 
Installation
------------

This module supports two types of installation: standalone run or using git hooks, to ensure
your team doesn't commit anything that doesn't match drupal code standards or best practices.

Before configuring is important to download all the dependencies. Please run:

```
cd drupal-validation
composer install
```

### Git Hooks

Symlink the `commit-msg` and `pre-commit` scripts to the hooks folder in the 
project git folder.

```
cd .git/hooks
ln -s ../drupal-validation/git-hooks/commit-msg.sh commit-msg
ln -s ../drupal-validation/git-hooks/pre-commit.sh pre-commit
ln -s ../drupal-validation/git-hooks/pre-push.sh pre-push
```

## Configuration

The code sniffer is using the Drupal code standard provided by drupal/code dependency.

The PHPMD config is set in the file `rules.xml`. See [the available rules](http://phpmd.org/rules/index.html)
and [documentation](http://phpmd.org/documentation/index.html) on configuring the
ruleset.

Place a file called settings.cfg in the drupal-validation folder. This file will be ignored by the git 
repository and will contain all the information the scripts need to work.

The properties to set are:

#### CONFIG_REGEX

This parameter contains the JIRA or other ticket management system integration for your project. In this example,
only commits with SC-XXXX, DWEB-XXXX or COR-XXXX, in addition to merge messages will be allowed. If the user
tries to commit something and forgets adding the ticket id in the message the commit will automatically fail.

```
COMMIT_REGEX='(sc-[0-9]+|dweb-[0-9]+|cor-[0-9]+|merge)'
```

#### PROJECT

This parameter contains the DRUPAL_ROOT value where the system is expecting a valid drupal installation.
It's important for when executing the validation through git hooks.

```
PROJECT=/sites/mysite/docroot
```

#### PROJECT_PATHS

This parameters contains the paths inside project that will be checked.
Note that the paths must contain the PROJECT part.

```
PROJECT_PATHS=(
  /sites/mysite/docroot/sites/all/modules/custom
  /sites/mysite/docroot/sites/all/themes/custom
)
```

#### PROJECT_IGNORE

Optional. Ignores the following path with rgexp. Defaults to:
 
```
PROJECT_IGNORE='/libraries/\|/contrib/'
```

#### PROJECT_INCLUDE

Optional. Specifies the files that will be processed during code validations. Defaults to:

```
PROJECT_INCLUDE='\.php\|\.module\|\.inc\|\.install'
```

## Running

To run manually the script, just type:

```
./run.sh
```

If you want to see the different options type:

```
./run.sh -h
```

To print the configuration loaded, run it with the 'p' option activated:

```
./run.sh -p
```

To enable extra debug mode, run it with the 'd' option activated:

```
./run.sh -d
```