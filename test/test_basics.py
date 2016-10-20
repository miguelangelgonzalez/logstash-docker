from helpers import environment, stdout_of, stderr_of
from constants import java_version_string, logstash_version_string


def test_java_is_the_correct_version():
    assert java_version_string in stderr_of('java -version')


def test_logstash_is_the_correct_version():
    assert logstash_version_string in stdout_of('logstash --version')


def test_the_default_user_is_logstash():
    assert stdout_of('whoami') == 'logstash'


def test_that_the_user_home_directory_is_slash_logstash():
    assert environment('HOME') == '/logstash'


def test_locale_variables_are_set_correctly():
    assert environment('LANG') == 'en_US.UTF-8'
    assert environment('LC_ALL') == 'en_US.UTF-8'


def test_slash_logstash_is_a_symlink_to_opt_logstash():
    assert stdout_of('realpath /logstash') == '/opt/logstash'


def test_all_files_in_opt_logstash_are_owned_by_logstash():
    assert stdout_of('find /opt/logstash ! -user logstash') == ''


def test_logstash_user_is_uid_1000():
    assert stdout_of('id -u logstash') == '1000'


def test_logstash_user_is_gid_1000():
    assert stdout_of('id -g logstash') == '1000'