<?php
foreach (get_loaded_extensions() as $i => $ext) {
    echo $ext .' => '. phpversion($ext). '<br/>';
}
phpinfo(INFO_GENERAL);
?>