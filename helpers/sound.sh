if aplay -l | grep "Generic \[HD-Audio Generic\]" --quiet > /dev/null 2>&1; then
	FIX=1
else
	FIX=0
fi

PAM_ENV="${HOME}/.pam_environment"
if [ $FIX -eq 1 ]; then

	# just check if ALSA_CARD is set
	# nothing else should be messing with it (hopefully)
	if [ -z ${ALSA_CARD+x} ]; then
		echo "[ERR] ALSA_CARD is unset. login again for sound to work.";

		if ! grep "ALSA_CARD" ${PAM_ENV} --quiet > /dev/null 2>&1 ; then
			echo "ALSA_CARD DEFAULT=Generic" >> ${PAM_ENV}
		fi

	fi

else

	if [ -e ${PAM_ENV} ]; then
		sed -i '/^ALSA_CARD/d' ${PAM_ENV}
	fi

fi # FIX
