# vim: filetype=python

import os, re, sys

if sys.platform=='win32':
    #   Windows
    BOOST=r'f:\boost_root'
    BOOSTLIBPATH=r'f:\boost_root\lib'
    IM_INCLUDE_PATH=[r'C:\ImageMagick-6.2.4-windows-source\ImageMagick-6.2.4',r'E:\ImageMagick-6.2.4-windows-source\ImageMagick-6.2.4\Magick++\lib']
    IM_LIB_PATH=r'C:\ImageMagick-6.2.4-windows-source\ImageMagick-6.2.4\VisualMagick\lib'
    GD_LIBS=[i for i in os.listdir(IM_LIB_PATH) if i.endswith('.lib')]+['user32.lib','ws2_32.lib','ole32.lib','gdi32.lib','oleaut32.lib','Advapi32.lib']#['CORE_RL_magick_','CORE_RL_Magick++_']
    PYTHON_INCLUDE='F:\Python24\include'
    BOOST_PYTHON_LIB=['libboost_python-vc71-mt.lib']
    CPP_FLAGS=['/EHsc','/MD','/GR','-DWIN32','-DNeedFunctionPrototypes','-D_LIB','-D_VISUALC_','-DBOOST_PYTHON_STATIC_LIB']
else:
    #   Linux
    BOOST='/usr/local/include/boost-1_32/'
    BOOSTLIBPATH='/usr/local/lib/'
    IM_INCLUDE_PATH=['/usr/include']
    IM_LIB_PATH='/usr/lib/'
    GD_LIBS=['Magick','Magick++','Wand']
    PYTHON_INCLUDE='/usr/include/python2.4'
    BOOST_PYTHON_LIB=['libboost_python-gcc']
    CPP_FLAGS=['-DBOOST_PYTHON_STATIC_LIB','-O2']

#   setup the environment
env=Environment(
    LIBPATH=['./',BOOSTLIBPATH, IM_LIB_PATH],
    CPPPATH=[BOOST, PYTHON_INCLUDE] + IM_INCLUDE_PATH,
    RPATH=['./',BOOSTLIBPATH],
    CPPFLAGS=CPP_FLAGS
)

def fix_includes(target,source,env):
    for t in target:
        code=file(str(t)).read()
        code=re.sub(r'#include <.*?(Magick\+\+/.*?\.h)>',r'#include <\1>',code)
        code=re.sub(r'#include <(.*?helpers_src.*?\.h)>',r'#include "../\1"',code)
        file(str(t),'w').write(code)
 
#   setup pyste builder
def pyste_emitter(target,source,env):
    sources = ['pyste_src/%s' % s for s in source]
    targets = ['pythonmagick_src/_%s.cpp' % t for t in target]
    return (targets,sources)
env['BUILDERS']['Pyste'] = Builder(action = ['pyste.py --module=_PythonMagick --multiple --out=./pythonmagick_src -I %s $SOURCE' % IM_INCLUDE_PATH, fix_includes],
    emitter=pyste_emitter)

#   default is not to run pyste
if ARGUMENTS.get('pyste')=='yes':
    PYSTE_FILES=[f for f in os.listdir('pyste_src') if f.endswith('.pyste')]
    os.system('pyste.py --module=_PythonMagick --multiple --generate-main --out=./pythonmagick_src -I %s %s' % (
        IM_INCLUDE_PATH,' '.join(['pyste_src/%s' % f for f in PYSTE_FILES]))
    )
    for item in PYSTE_FILES:
        env.Pyste(item)

#   build the module
PM_FILES=['pythonmagick_src/%s'%f for f in os.listdir('pythonmagick_src') if f.endswith('.cpp')]
HELPER_FILES=['helpers_src/%s'%f for f in os.listdir('helpers_src') if f.endswith('.cpp')]
env.SharedLibrary(
    target='PythonMagick/_PythonMagick',
    source=PM_FILES+HELPER_FILES,
    SHLIBPREFIX='',
    LIBS=BOOST_PYTHON_LIB+GD_LIBS
)
