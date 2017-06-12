# arc-theme

```bash
git clone git@github.com:horst3180/arc-theme.git;
cd arc-theme
mkdir build
./autogen.sh --prefix=$( pwd )/build
make install
ln -s $( pwd )/build/share/themes/Arc-Dark ${HOME}/.themes/Arc-Dark
```

# arc-icon-theme

```bash
git clone git@github.com:horst3180/arc-icon-theme.git;
cd arc-icon-theme
mkdir build
./autogen.sh --prefix=$( pwd )/build
ln -s $( pwd )/build/share/icons/Arc ${HOME}/.icons/Arc
make install
```

# breeze-hacked

```bash
git clone git@github.com:thewisenerd/Breeze_Hacked.git;
cd Breeze_Hacked
./build.sh
ln -s $( pwd )/Breeze_Hacked ${HOME}/.icons/Breeze_Hacked
ln -s $( pwd )/Breeze_Hacked/cursors ${HOME}/.icons/default/cursors
```
