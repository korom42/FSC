
keytest() {
  ui_print "** Vol Key Test **"
  ui_print "** Press Vol UP **"
  (/system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events) || return 1
  return 0
}

chooseport() {
  #note from chainfire @xda-developers: getevent behaves weird when piped, and busybox grep likes that even less than toolbox/toybox grep
  while true; do
    /system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events
    if (`cat $INSTALLER/events 2>/dev/null | /system/bin/grep VOLUME >/dev/null`); then
      break
    fi
  done
  if (`cat $INSTALLER/events 2>/dev/null | /system/bin/grep VOLUMEUP >/dev/null`); then
    return 0
  else
    return 1
  fi
}

chooseportold() {
  # Calling it first time detects previous input. Calling it second time will do what we want
  $KEYCHECK
  $KEYCHECK
  SEL=$?
  if [ "$1" == "UP" ]; then
    UP=$SEL
  elif [ "$1" == "DOWN" ]; then
    DOWN=$SEL
  elif [ $SEL -eq $UP ]; then
    return 0
  elif [ $SEL -eq $DOWN ]; then
    return 1
  else
    ui_print "**  Vol key not detected **"
    abort "** Use name change method in TWRP **"
  fi
}


# GET OLD/NEW FROM ZIP NAME
case $(echo $(basename $ZIP) | tr '[:upper:]' '[:lower:]') in
  *harm*) PROFILEMODE=0;;
  *extrem*) PROFILEMODE=1;;
esac


# Keycheck binary by someone755 @Github, idea for code below by Zappo @xda-developers
KEYCHECK=$INSTALLER/common/keycheck
chmod 755 $KEYCHECK


device_check() {
  if [ "$(grep_prop ro.product.device)" == "$1" ]; then
    return 0
  else
    return 1
  fi
}

if [ $(grep_prop ro.build.version.sdk) -ge "26" ] ;then
  dir="vendor/etc"
else
  dir="system/etc"
fi

ui_print " "
support=0
multiprofile=0

if device_check "akatsuki" || device_check "akatsuki_dsds"; then
  ui_print "  Xperia XZ3 detected"
  device="XZ3"
  support=1
  multiprofile=1
fi

if device_check "aurora" || device_check "aurora_dsds"; then
  ui_print "  Xperia XZ2 Premium detected"
  device="XZ3"
  support=1
  multiprofile=1
fi

if device_check "akari" || device_check "akari_dsds"; then
  ui_print "  Xperia XZ2 detected"
  device="XZ3"
  support=1
  multiprofile=1
fi

if device_check "poplar" || device_check "poplar_dsds"; then
  ui_print "  Xperia XZ1 detected"
  device="XZ1"
  support=1
  multiprofile=1
fi

if device_check "lilac" || device_check "lilac_dsds"; then
  ui_print "  Xperia XZ1 Compact detected"
  device="XZ1"
  support=1
  multiprofile=1
fi

if device_check "maple" || device_check "maple_dsds"; then
  ui_print "  Xperia XZ Premium detected"
  device="XZ1"
  support=1
  multiprofile=1
fi

if device_check "keyaki" || device_check "keyaki_dsds"; then
  ui_print "  Xperia XZs detected"
  device="XZ"
  support=1
  multiprofile=1
fi

if device_check "kagura" || device_check "kagura_dsds"; then
  ui_print "  Xperia XZ detected"
  device="XZ"
  support=1
  multiprofile=1
fi

if device_check "Dora" || device_check "Dora_dsds"; then
  ui_print "  Xperia X Performance detected"
  device="XZ"
  support=1
  multiprofile=1
fi

if device_check "satsuki" || device_check "satsuki_dsds"; then
  ui_print "  Xperia Z5 Premium detected"
  device="Z5"
  support=1
fi

if device_check "sumire" || device_check "sumire_dsds"; then
  ui_print "  Xperia Z5 detected"
  device="Z5"
  support=1
fi

if device_check "ivy" || device_check "ivy_dsds"; then
  ui_print "  Xperia Z3+ detected"
  device="Z4"
  support=1
fi

    if [ $support -eq "0" ];then
	  ui_print "  Your device is not supported"
	  abort "  Aborting"
	fi

  ui_print "** DISCLAIMER **"
  ui_print " "
  ui_print "   Use at your own risk"
  ui_print "   I am not responsible for any damage that could happen"
  ui_print "   Please do some research if you do not know how this mod works"
  ui_print " "
  ui_print " "

sleep "1"
  
if [ -z $PROFILEMODE ] ; then


  ui_print " "
  ui_print ".######...####....####.."
  ui_print ".##......##......##..##."
  ui_print ".######...####...##....."
  ui_print ".##..........##..##..##."
  ui_print ".##.......####....####.."
  ui_print "........................"
  ui_print " "
  if [ $multiprofile -eq "1" ];then
  if keytest; then
    FUNCTION=chooseport
  else
    FUNCTION=chooseportold
    ui_print "** Volume button programming **"
    ui_print " "
    ui_print "** Press Vol UP again **"
    $FUNCTION "UP"
    ui_print "**  Press Vol DOWN **"
    $FUNCTION "DOWN"
  fi
 
  ui_print "** Choose Thermal tweaks mode **"
  ui_print " "
  ui_print "   1. Balanced"
  ui_print "   2. Performance Boost"
  ui_print " "
  ui_print "** Please choose tweaks mode **"
  ui_print " "
  ui_print "   Vol(+) = Balanced (Recommended)"
  ui_print "   Vol(-) = Performance Maximizer"
  ui_print " "
  
    if $FUNCTION; then
    PROFILEMODE=0
    ui_print "   Balanced mode selected."
    ui_print " "
    cp -f $INSTALLER/devices/$device/0/thermal-engine.conf  $INSTALLER/$dir/thermal-engine.conf
    else
    PROFILEMODE=1
    ui_print "   Performance Maximizer mode selected."
    ui_print " "
    cp -f $INSTALLER/devices/$device/1/thermal-engine.conf  $INSTALLER/$dir/thermal-engine.conf
    fi
	
	else
    PROFILEMODE=0
    ui_print "   Extracting files."
    ui_print " "
    cp -f $INSTALLER/devices/$device/0/thermal-engine.conf  $INSTALLER/$dir/thermal-engine.conf
	fi

  fi
