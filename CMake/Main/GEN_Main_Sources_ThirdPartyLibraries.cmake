# --------------------------------------------------------------------
# GEN_Main_Sources_ThirdPartyLibraries.cmake
# Main: Sources Third Party Libraries
# --------------------------------------------------------------------


# ANGLE is a Windows GLES translator; never compile it unless OpenGL ES is enabled for this target.
if(GRP_OPENGL_FEATURE AND THIRDPARTYLIBRARIES_ANGLE_FEATURE)

  list(APPEND GEN_THIRDPARTY_LIBRARYS ANGLE)

  add_definitions(-DANGLE_STATIC)
  add_definitions(-DANGLE_EXPORT=)
  add_definitions(-DANGLE_UTIL_EXPORT=)
  add_definitions(-DANGLE_CAPTURE_ENABLED=0)
  add_definitions(-DANGLE_ENABLE_GLSL)
  add_definitions(-DANGLE_ENABLE_OPENGL)
  add_definitions(-DANGLE_ENABLE_GL_DESKTOP_BACKEND)
  add_definitions(-DEGLAPI=)
  add_definitions(-DGL_API=)
  add_definitions(-DGL_APICALL=)
  add_definitions(-DLIBANGLE_IMPLEMENTATION)
  add_definitions(-DLIBGLESV2_IMPLEMENTATION)
  add_definitions(-DLIBEGL_IMPLEMENTATION)
  add_definitions(-DANGLE_PLATFORM_WINDOWS)
  add_definitions(-DANGLE_ENABLE_HLSL)    

  add_compile_definitions(NOMINMAX)
  

  file(MAKE_DIRECTORY "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE_COMMON_GENERATED}")
  file(WRITE "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE_COMMON_GENERATED}/ANGLEShaderProgramVersion.h"     "#ifndef ANGLE_SHADER_PROGRAM_VERSION_H_\n#define ANGLE_SHADER_PROGRAM_VERSION_H_\n#define ANGLE_PROGRAM_VERSION \"GEN_BUILD\"\n#define ANGLE_PROGRAM_VERSION_HASH_SIZE 9\n#endif\n")
  file(WRITE "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE_COMMON_GENERATED}/angle_commit.h"                  "#ifndef ANGLE_COMMIT_H_\n#define ANGLE_COMMIT_H_\n#define ANGLE_COMMIT_HASH \"GEN_BUILD\"\n#define ANGLE_COMMIT_HASH_SIZE 9\n#define ANGLE_COMMIT_POSITION 0\n#endif\n")
  file(WRITE "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE_COMMON_GENERATED}/compression_utils_portable.h"
  "#ifndef COMPRESSION_UTILS_PORTABLE_H_\n\
   #define COMPRESSION_UTILS_PORTABLE_H_\n\
   #include <zlib.h>\n\
   #include <stdint.h>\n\
   #include <stddef.h>\n\
   namespace zlib_internal {\n\
   inline uLong GzipExpectedCompressedSize(uLong input_size) {\n\
       return compressBound(input_size) + 18;\n\
   }\n\
   inline uint32_t GetGzipUncompressedSize(const uint8_t *compressed_data, size_t compressed_size) {\n\
       if (compressed_size < 4) return 0;\n\
       const uint8_t *p = compressed_data + compressed_size - 4;\n\
       return (uint32_t)p[0] | ((uint32_t)p[1] << 8) | ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);\n\
   }\n\
   inline int GzipCompressHelper(uint8_t *dest, uLong *dest_length,\n\
                                  const uint8_t *source, uLong source_length,\n\
                                  void*, void*) {\n\
       return compress2(dest, dest_length, source, source_length, Z_DEFAULT_COMPRESSION);\n\
   }\n\
   inline int GzipUncompressHelper(uint8_t *dest, uLong *dest_length,\n\
                                    const uint8_t *source, uLong source_length) {\n\
       return uncompress(dest, dest_length, source, source_length);\n\
   }\n\
   }  // namespace zlib_internal\n\
   #endif  // COMPRESSION_UTILS_PORTABLE_H_\n")

  
  set(GEN_TPL_SOURCES)

  # -------------------------------------------------------
  # common  � utilidades base, sin dependencias de plataforma
  # -------------------------------------------------------
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/CompiledShaderState.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/Float16ToFloat32.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/MemoryBuffer.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/PackedEnums.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/PackedEGLEnums_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/PackedGLEnums_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/PackedCLEnums_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/PoolAlloc.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/SimpleMutex.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/WorkerThread.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/aligned_memory.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/angle_version_info.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/angleutils.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/debug.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/entry_points_enum_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/event_tracer.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/gl_enum_utils.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/gl_enum_utils_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/mathutil.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/matrix_utils.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/platform_helpers.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/string_utils.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/system_utils.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/tls.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/uniform_type_info_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/utilities.cpp")    
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/system_utils_win.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/system_utils_win32.cpp")  
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/android_util.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/third_party/xxhash/xxhash.c")

  # -------------------------------------------------------
  # image_util  � carga/conversi�n de formatos de textura
  # -------------------------------------------------------
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/image_util/copyimage.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/image_util/imageformats.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/image_util/loadimage.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/image_util/loadimage_astc.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/image_util/loadimage_etc.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/image_util/loadimage_paletted.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/image_util/storeimage_paletted.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/image_util/AstcDecompressorNoOp.cpp")

  # -------------------------------------------------------
  # gpu_info_util  � detecci�n de GPU (necesario para Display)
  # -------------------------------------------------------
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/gpu_info_util/SystemInfo.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/gpu_info_util/SystemInfo_win.cpp")
  
  # -------------------------------------------------------
  # compiler/preprocessor  � preprocesador GLSL
  # -------------------------------------------------------
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/preprocessor/DiagnosticsBase.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/preprocessor/DirectiveHandlerBase.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/preprocessor/DirectiveParser.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/preprocessor/Input.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/preprocessor/Lexer.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/preprocessor/Macro.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/preprocessor/MacroExpander.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/preprocessor/Preprocessor.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/preprocessor/Token.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/preprocessor/preprocessor_lex_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/preprocessor/preprocessor_tab_autogen.cpp")

  # -------------------------------------------------------
  # compiler/translator  � compilador de shaders GLSL ES
  # N�cleo (independiente de backend)
  # -------------------------------------------------------
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/BaseTypes.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/BuiltInFunctionEmulator.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/CallDAG.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/CodeGen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/CollectVariables.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/Compiler.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/ConstantUnion.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/Declarator.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/Diagnostics.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/DirectiveHandler.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/ExtensionBehavior.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/FlagStd140Structs.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/FunctionLookup.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/HashNames.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/ImmutableStringBuilder.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/ImmutableString_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/InfoSink.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/Initialize.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/IntermNode.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/IntermRebuild.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/IsASTDepthBelowLimit.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/Name.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/Operator.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/OutputTree.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/ParseContext.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/PoolAlloc.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/QualifierTypes.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/ShaderLang.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/ShaderVars.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/SizeClipCullDistance.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/Symbol.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/SymbolTable.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/SymbolTable_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/SymbolUniqueId.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/Types.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/ValidateAST.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/ValidateGlobalInitializer.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/ValidateVaryingLocations.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/VariablePacker.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/blocklayout.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/util.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/glslang_lex_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/glslang_tab_autogen.cpp")

  # tree_util (utilidades de recorrido del AST � compartidas por todos los backends)
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_util/DriverUniform.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_util/FindFunction.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_util/FindMain.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_util/FindPreciseNodes.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_util/FindSymbolNode.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_util/IntermNodePatternMatcher.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_util/IntermNode_util.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_util/IntermTraverse.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_util/ReplaceArrayOfMatrixVarying.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_util/ReplaceClipCullDistanceVariable.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_util/ReplaceShadowingVariables.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_util/ReplaceVariable.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_util/RewriteSampleMaskVariable.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_util/RunAtTheBeginningOfShader.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_util/RunAtTheEndOfShader.cpp")

  # tree_ops comunes (transformaciones del AST independientes de backend de salida)
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/AddDefaultReturnStatements.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/ClampFragDepth.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/ClampIndirectIndices.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/ClampPointSize.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/DeclareAndInitBuiltinsForInstancedMultiview.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/DeclarePerVertexBlocks.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/DeferGlobalInitializers.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/EmulateGLFragColorBroadcast.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/EmulateMultiDrawShaderBuiltins.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/FoldExpressions.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/GatherDefaultUniforms.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/InitializeVariables.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/MonomorphizeUnsupportedFunctions.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/PreTransformTextureCubeGradDerivatives.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/PruneEmptyCases.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/PruneNoOps.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/RecordConstantPrecision.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/ReduceInterfaceBlocks.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/RemoveArrayLengthMethod.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/RemoveAtomicCounterBuiltins.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/RemoveDynamicIndexing.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/RemoveInactiveInterfaceVariables.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/RemoveInvariantDeclaration.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/RemoveUnreferencedVariables.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/RemoveUnusedFramebufferFetch.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/RewriteArrayOfArrayOfOpaqueUniforms.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/RewriteAtomicCounters.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/RewriteDfdy.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/RewritePixelLocalStorage.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/RewriteStructSamplers.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/RewriteTexelFetchOffset.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/ScalarizeVecAndMatConstructorArgs.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/SeparateDeclarations.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/SeparateStructFromUniformDeclarations.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/SimplifyLoopConditions.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/SplitSequenceOperator.cpp")

  # tree_ops/glsl (transformaciones espec�ficas del backend GLSL � Windows y Linux)
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/glsl/ExpandFragmentOutputsToVec4.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/glsl/RegenerateStructNames.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/glsl/RewriteRepeatedAssignToSwizzled.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/glsl/UseInterfaceBlockFields.cpp")

  # tree_ops/hlsl (solo Windows � traducci�n a HLSL/D3D via WGL no aplica, pero
  # CodeGen.cpp los referencia en tiempo de compilaci�n; incluir si se activa D3D)
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/hlsl/ArrayReturnValueToOutParameter.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/hlsl/BreakVariableAliasingInInnerLoops.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/hlsl/ExpandIntegerPowExpressions.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/hlsl/RecordUniformBlocksWithLargeArrayMember.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/hlsl/RemoveSwitchFallThrough.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/hlsl/RewriteElseBlocks.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/hlsl/RewriteUnaryMinusOperatorInt.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/hlsl/SeparateArrayConstructorStatements.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/hlsl/SeparateArrayInitialization.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/hlsl/SeparateExpressionsReturningArrays.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/hlsl/UnfoldShortCircuitToIf.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/tree_ops/hlsl/WrapSwitchStatementsInBlocks.cpp")

  # translator/glsl � backend de salida GLSL (Windows WGL + Linux GLX/EGL)
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/glsl/BuiltInFunctionEmulatorGLSL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/glsl/ExtensionGLSL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/glsl/OutputESSL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/glsl/OutputGLSL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/glsl/OutputGLSLBase.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/glsl/TranslatorESSL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/glsl/TranslatorGLSL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/glsl/VersionGLSL.cpp")

  # translator/hlsl � backend HLSL (solo Windows con renderer D3D, si aplica)
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/hlsl/ASTMetadataHLSL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/hlsl/BuiltInFunctionEmulatorHLSL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/hlsl/ImageFunctionHLSL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/hlsl/OutputHLSL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/hlsl/ResourcesHLSL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/hlsl/StructureHLSL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/hlsl/TextureFunctionHLSL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/hlsl/TranslatorHLSL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/hlsl/UtilsHLSL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/hlsl/blocklayoutHLSL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/hlsl/emulated_builtin_functions_hlsl_autogen.cpp")
  
  # -------------------------------------------------------
  # libANGLE  � n�cleo de la implementaci�n EGL/GLES
  # -------------------------------------------------------
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/AttributeMap.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/BlobCache.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Buffer.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Caps.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Compiler.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Config.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Context.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/ContextMutex.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Context_gles_1_0.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Debug.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Device.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Display.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/EGLSync.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Error.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Fence.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Framebuffer.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/FramebufferAttachment.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/GLES1Renderer.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/GLES1State.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/GlobalMutex.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/HandleAllocator.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Image.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/ImageIndex.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/IndexRangeCache.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/LoggingAnnotator.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/MemoryObject.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/MemoryProgramCache.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/MemoryShaderCache.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Observer.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Overlay.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/OverlayWidgets.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Overlay_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Overlay_font_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/PixelLocalStorage.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Platform.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Program.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/ProgramExecutable.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/ProgramLinkedResources.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/ProgramPipeline.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Query.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Renderbuffer.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/ResourceManager.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Sampler.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Semaphore.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Shader.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/ShareGroup.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/State.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Stream.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Surface.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Texture.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Thread.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/TransformFeedback.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/Uniform.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/VaryingPacking.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/VertexArray.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/VertexAttribute.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/angletypes.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/es3_copy_conversion_table_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/format_map_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/formatutils.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/gles_extensions_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/queryconversions.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/queryutils.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/validationEGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/validationES.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/validationES1.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/validationES2.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/validationES3.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/validationES31.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/validationES32.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/validationESEXT.cpp")

  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/capture/FrameCapture_mock.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/capture/serialize_mock.cpp")

  # libANGLE/renderer � capa de abstracci�n del renderer (base, independiente)
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/BufferImpl.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/ContextImpl.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/DeviceImpl.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/DisplayImpl.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/EGLReusableSync.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/EGLSyncImpl.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/Format_table_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/FramebufferImpl.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/ImageImpl.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/ProgramImpl.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/ProgramPipelineImpl.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/QueryImpl.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/RenderbufferImpl.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/ShaderImpl.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/SurfaceImpl.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/TextureImpl.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/TransformFeedbackImpl.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/VertexArrayImpl.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/driver_utils.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/load_functions_table_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/renderer_utils.cpp")

  # Windows: archivos dxgi necesarios aunque se use WGL (Display los referencia)
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/d3d_format.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/dxgi_format_map_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/dxgi_support_table_autogen.cpp")
  
  # renderer/gl � implementaci�n OpenGL nativa (base, com�n a WGL/GLX/EGL)
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/BlitGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/BufferGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/ClearMultiviewGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/CompilerGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/ContextGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/DispatchTableGL_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/DisplayGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/FenceNVGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/FramebufferGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/FunctionsGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/ImageGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/MemoryObjectGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/ProgramExecutableGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/ProgramGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/ProgramPipelineGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/QueryGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/RenderbufferGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/RendererGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/SamplerGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/SemaphoreGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/ShaderGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/StateManagerGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/SurfaceGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/SyncGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/TextureGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/TransformFeedbackGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/VertexArrayGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/formatutilsgl.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/renderergl_utils.cpp")

  # renderer/gl/wgl � backend Windows (WGL sobre OpenGL nativo)
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/wgl/ContextWGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/wgl/D3DTextureSurfaceWGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/wgl/DXGISwapChainWindowSurfaceWGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/wgl/DisplayWGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/wgl/FunctionsWGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/wgl/PbufferSurfaceWGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/wgl/RendererWGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/wgl/WindowSurfaceWGL.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libANGLE/renderer/gl/wgl/wgl_utils.cpp")
  
  
  # -------------------------------------------------------
  # libGLESv2  � entry points de GLES2/3 y EGL
  # -------------------------------------------------------
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libGLESv2/egl_stubs.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libGLESv2/egl_ext_stubs.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libGLESv2/egl_stubs_getprocaddress_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libGLESv2/entry_points_egl_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libGLESv2/entry_points_egl_ext_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libGLESv2/entry_points_gles_1_0_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libGLESv2/entry_points_gles_2_0_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libGLESv2/entry_points_gles_3_0_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libGLESv2/entry_points_gles_3_1_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libGLESv2/entry_points_gles_3_2_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libGLESv2/entry_points_gles_ext_autogen.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libGLESv2/global_state.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libGLESv2/libGLESv2_autogen.cpp")
 
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/libEGL/libEGL_autogen.cpp")

  list(APPEND GEN_SOURCES_MODULES_LIST ${GEN_TPL_SOURCES})
    
  set_source_files_properties(${GEN_TPL_SOURCES} PROPERTIES COMPILE_FLAGS "/std:c++20")

  set_source_files_properties("${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/glslang_lex_autogen.cpp"
                              "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/compiler/translator/glslang_tab_autogen.cpp"
                                PROPERTIES COMPILE_FLAGS "/std:c++20 /URESTRICT"
                              )

  set_source_files_properties("${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/common/third_party/xxhash/xxhash.c" PROPERTIES COMPILE_FLAGS "" )
  set_source_files_properties("${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ANGLE_SOURCE}/third_party/libXNVCtrl/NVCtrl.c"    PROPERTIES COMPILE_FLAGS "" )
    
  GEN_ThirdPartyLibraries_SuppressWarnings(ANGLE ${GEN_TPL_SOURCES})

endif()


   
if(THIRDPARTYLIBRARIES_ZLIB_FEATURE)
  
  list(APPEND GEN_THIRDPARTY_LIBRARYS ZLib)

  set(GEN_TPL_SOURCES)
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ZLIB}/adler32.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ZLIB}/compress.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ZLIB}/crc32.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ZLIB}/deflate.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ZLIB}/infback.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ZLIB}/inffast.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ZLIB}/inflate.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ZLIB}/inftrees.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ZLIB}/trees.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ZLIB}/uncompr.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ZLIB}/zutil.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ZLIB_MINIZIP}/ioapi.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ZLIB_MINIZIP}/unzip.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_ZLIB_MINIZIP}/zip.c")

  list(APPEND GEN_SOURCES_MODULES_LIST ${GEN_TPL_SOURCES})
  GEN_ThirdPartyLibraries_SuppressWarnings(ZLib ${GEN_TPL_SOURCES})

endif()



if(THIRDPARTYLIBRARIES_AGG_FEATURE)

  list(APPEND GEN_THIRDPARTY_LIBRARYS AGG)

  set(GEN_TPL_SOURCES)
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_arc.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_arrowhead.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_bezier_arc.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_bspline.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_curves.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_embedded_raster_fonts.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_gsv_text.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_image_filters.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_line_aa_basics.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_line_profile_aa.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_rounded_rect.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_sqrt_tables.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_trans_affine.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_trans_double_path.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_trans_single_path.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_trans_warp_magnifier.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_vcgen_bspline.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_vcgen_contour.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_vcgen_dash.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_vcgen_markers_term.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_vcgen_smooth_poly1.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_vcgen_stroke.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_vpgen_clip_polygon.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_vpgen_clip_polyline.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_SOURCES}/agg_vpgen_segmentator.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_AGG_FREETYPE}/agg_font_freetype.cpp")

  list(APPEND GEN_SOURCES_MODULES_LIST ${GEN_TPL_SOURCES})

  GEN_ThirdPartyLibraries_SuppressWarnings(AGG ${GEN_TPL_SOURCES})

endif()



if(THIRDPARTYLIBRARIES_FREETYPE_FEATURE)

  list(APPEND GEN_THIRDPARTY_LIBRARYS FreeType)

  #add_definitions(-DFT_CONFIG_OPTION_FORCE_INT64)

  set(GEN_TPL_SOURCES)
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/base/ftbbox.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/base/ftbdf.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/base/ftbitmap.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/base/ftcid.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/base/ftfstype.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/base/ftgasp.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/base/ftglyph.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/base/ftgxval.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/base/ftmm.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/base/ftotval.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/base/ftpatent.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/base/ftpfr.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/base/ftstroke.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/base/ftsynth.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/base/fttype1.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/base/ftwinfnt.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/autofit/autofit.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/base/ftbase.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/cache/ftccache.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/base/ftdebug.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/bdf/bdf.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/gzip/ftgzip.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/cff/cff.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/base/ftinit.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/lzw/ftlzw.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/base/ftsystem.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/pcf/pcf.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/pfr/pfr.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/psaux/psaux.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/pshinter/pshinter.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/psnames/psmodule.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/raster/raster.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/sfnt/sfnt.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/smooth/smooth.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/truetype/truetype.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/type1/type1.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/cid/type1cid.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/type42/type42.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/winfonts/winfnt.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/cache/ftcmru.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/cache/ftcmanag.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/sdf/sdf.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_FREETYPE_SOURCES}/svg/svg.c")

  list(APPEND GEN_SOURCES_MODULES_LIST ${GEN_TPL_SOURCES})
  GEN_ThirdPartyLibraries_SuppressWarnings(FreeType ${GEN_TPL_SOURCES})

endif()



if(THIRDPARTYLIBRARIES_JPEGLIB_FEATURE)

  list(APPEND GEN_THIRDPARTY_LIBRARYS JPEGLib)

  set(GEN_TPL_SOURCES)
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jaricom.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jcapimin.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jcapistd.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jcarith.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jccoefct.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jccolor.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jcdctmgr.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jchuff.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jcinit.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jcmainct.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jcmarker.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jcmaster.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jcomapi.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jcparam.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jcprepct.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jcsample.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jctrans.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jdapimin.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jdapistd.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jdarith.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jdatadst.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jdatasrc.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jdcoefct.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jdcolor.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jddctmgr.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jdhuff.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jdinput.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jdmainct.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jdmarker.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jdmaster.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jdmerge.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jdpostct.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jdsample.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jdtrans.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jerror.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jfdctflt.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jfdctfst.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jfdctint.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jidctflt.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jidctfst.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jidctint.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jmemmgr.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jmemnobs.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jquant1.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jquant2.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_JPEGLIB}/jutils.c")

  list(APPEND GEN_SOURCES_MODULES_LIST ${GEN_TPL_SOURCES})
  GEN_ThirdPartyLibraries_SuppressWarnings(JPEGLib ${GEN_TPL_SOURCES})

endif()



if(THIRDPARTYLIBRARIES_LIBPNG_FEATURE)

  list(APPEND GEN_THIRDPARTY_LIBRARYS LibPNG)

  set(GEN_TPL_SOURCES)
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LIBPNG}/png.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LIBPNG}/pngerror.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LIBPNG}/pngget.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LIBPNG}/pngmem.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LIBPNG}/pngpread.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LIBPNG}/pngread.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LIBPNG}/pngrio.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LIBPNG}/pngrtran.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LIBPNG}/pngrutil.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LIBPNG}/pngset.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LIBPNG}/pngtrans.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LIBPNG}/pngwio.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LIBPNG}/pngwrite.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LIBPNG}/pngwtran.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LIBPNG}/pngwutil.c")

  if(COMPILE_FOR_LINUX_ARM_RPI OR COMPILE_FOR_LINUX_ARM OR COMPILE_FOR_LINUX_ARM_RPI_64 OR COMPILE_FOR_LINUX_ARM_64 OR COMPILE_FOR_ANDROID32 OR COMPILE_FOR_ANDROID64)

    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LIBPNG}/arm/arm_init.c")
    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LIBPNG}/arm/palette_neon_intrinsics.c")
    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LIBPNG}/arm/filter_neon_intrinsics.c")

  endif()

  list(APPEND GEN_SOURCES_MODULES_LIST ${GEN_TPL_SOURCES})
  GEN_ThirdPartyLibraries_SuppressWarnings(LibPNG ${GEN_TPL_SOURCES})

endif()



if(THIRDPARTYLIBRARIES_OPENAL_FEATURE)  
  
  list(APPEND GEN_THIRDPARTY_LIBRARYS OpenAL)

  set(CMAKE_CXX_STANDARD 17)

  add_definitions(-DAL_LIBTYPE_STATIC)
  add_definitions(-DAL_BUILD_LIBRARY)

  add_definitions(-DALC_API=)
  add_definitions(-DAL_API=)

  add_definitions(-DNOMINMAX)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)  
  add_definitions(-DRESTRICT=__restrict) 
  add_definitions(-DAL_ALEXT_PROTOTYPES)
  add_definitions(-DCMAKE_INTDIR="Debug")
  add_definitions(-DOpenAL_EXPORTS)
  add_definitions(-DFMT_HEADER_ONLY)

  if(IS_ABSOLUTE "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}")
    set(_GEN_OPENAL_TEMPLATES_DIR "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}")
  else()
    get_filename_component(_GEN_OPENAL_TEMPLATES_DIR "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}" ABSOLUTE BASE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
  endif()

  set(_GEN_OPENAL_GENERATED_DIR             "${_GEN_OPENAL_TEMPLATES_DIR}/generated")
  set(_GEN_OPENAL_GENERATED_PLATFORM_DIR    "")
  set(_GEN_OPENAL_ANDROID_ABI               "")

  if(NOT EXISTS "${_GEN_OPENAL_TEMPLATES_DIR}/config.h.in")
    message(FATAL_ERROR "[ GEN OpenAL] OpenAL Soft 1.24.3 templates were not found in ${_GEN_OPENAL_TEMPLATES_DIR}. Replace ThirdPartyLibraries/openal-soft with OpenAL Soft 1.24.3 before configuring.")
  endif()

  set(ALSOFT_FORCE_ALIGN "")

  unset(ALSOFT_EMBED_HRTF_DATA)
  unset(HAVE_PROC_PIDPATH)
  unset(HAVE_DLFCN_H)
  unset(HAVE_PTHREAD_NP_H)
  unset(HAVE_CPUID_H)
  unset(HAVE_INTRIN_H)
  unset(HAVE_GUIDDEF_H)
  unset(HAVE_GCC_GET_CPUID)
  unset(HAVE_CPUID_INTRINSIC)
  unset(HAVE_PTHREAD_SETSCHEDPARAM)
  unset(HAVE_PTHREAD_SETNAME_NP)
  unset(HAVE_PTHREAD_SET_NAME_NP)
  unset(ALSOFT_INSTALL_DATADIR)

  set(HAVE_RTKIT          0)
  set(ALSOFT_UWP          0)
  set(ALSOFT_EAX          0)

  set(HAVE_ALSA           0)
  set(HAVE_OSS            0)
  set(HAVE_PIPEWIRE       0)
  set(HAVE_SOLARIS        0)
  set(HAVE_SNDIO          0)
  set(HAVE_WASAPI         0)
  set(HAVE_DSOUND         0)
  set(HAVE_WINMM          0)
  set(HAVE_PORTAUDIO      0)
  set(HAVE_PULSEAUDIO     0)
  set(HAVE_JACK           0)
  set(HAVE_COREAUDIO      0)
  set(HAVE_OPENSL         0)
  set(HAVE_OBOE           0)
  set(HAVE_OTHERIO        0)
  set(HAVE_WAVE           0)
  set(HAVE_SDL3           0)
  set(HAVE_SDL2           0)

  set(HAVE_SSE            0)
  set(HAVE_SSE2           0)
  set(HAVE_SSE3           0)
  set(HAVE_SSE4_1         0)
  set(HAVE_SSE_INTRINSICS 0)
  set(HAVE_NEON           0)

  set(LIB_VERSION         "1.24.3")
  set(LIB_VERSION_NUM     "1,24,3,0")
  set(GIT_BRANCH          "UNKNOWN")
  set(GIT_COMMIT_HASH     "unknown")

  if(COMPILE_FOR_WINDOWS)  
 
    add_definitions(-DWIN32)
    add_definitions(-D_WIN32)
    add_definitions(-D_WINDOWS)
    add_definitions(-DWINDOWS)

    if(COMPILE_FOR_WINDOWS_INTEL_32)
      set(_GEN_OPENAL_GENERATED_PLATFORM_DIR "${_GEN_OPENAL_GENERATED_DIR}/windows/intel32")
    endif()

    if(COMPILE_FOR_WINDOWS_INTEL_64)
      set(_GEN_OPENAL_GENERATED_PLATFORM_DIR "${_GEN_OPENAL_GENERATED_DIR}/windows/intel64")
    endif()

    set(HAVE_INTRIN_H          1)
    set(HAVE_GUIDDEF_H         1)
    set(HAVE_CPUID_INTRINSIC   1)

    set(ALSOFT_EAX             1)

    set(HAVE_WASAPI            1)
    set(HAVE_DSOUND            1)
    set(HAVE_WINMM             1)
    set(HAVE_WAVE              1)

    set(HAVE_SSE               1)
    set(HAVE_SSE2              1)
    set(HAVE_SSE3              1)
    set(HAVE_SSE4_1            1)
    set(HAVE_SSE_INTRINSICS    1)

  endif()

  if(COMPILE_FOR_LINUX)  

    if(COMPILE_FOR_LINUX_INTEL_64)
      set(_GEN_OPENAL_GENERATED_PLATFORM_DIR "${_GEN_OPENAL_GENERATED_DIR}/linux/intel64")

      set(HAVE_CPUID_H          1)
      set(HAVE_GCC_GET_CPUID    1)

      set(HAVE_SSE              1)
      set(HAVE_SSE2             1)
      set(HAVE_SSE3             1)
      set(HAVE_SSE4_1           1)
      set(HAVE_SSE_INTRINSICS   1)
    endif()

    if(COMPILE_FOR_LINUX_ARM)
      set(_GEN_OPENAL_GENERATED_PLATFORM_DIR "${_GEN_OPENAL_GENERATED_DIR}/linux/arm32")
    endif()

    if(COMPILE_FOR_LINUX_ARM_64)
      set(_GEN_OPENAL_GENERATED_PLATFORM_DIR "${_GEN_OPENAL_GENERATED_DIR}/linux/arm64")
      set(HAVE_NEON 1)
    endif()

    if(COMPILE_FOR_LINUX_ARM_RPI)
      set(_GEN_OPENAL_GENERATED_PLATFORM_DIR "${_GEN_OPENAL_GENERATED_DIR}/linux/rpi32")
    endif()

    if(COMPILE_FOR_LINUX_ARM_RPI_64)
      set(_GEN_OPENAL_GENERATED_PLATFORM_DIR "${_GEN_OPENAL_GENERATED_DIR}/linux/rpi64")
      set(HAVE_NEON 1)
    endif()

    set(HAVE_DLFCN_H              1)
    set(HAVE_PTHREAD_SETSCHEDPARAM 1)
    set(HAVE_PTHREAD_SETNAME_NP   1)

    set(HAVE_RTKIT                1)

    set(HAVE_ALSA                 1)
    set(HAVE_OSS                  1)
    set(HAVE_PULSEAUDIO           1)
    set(HAVE_WAVE                 1)

  endif()

  if(COMPILE_FOR_ANDROID32 OR COMPILE_FOR_ANDROID64)   

    if(DEFINED ANDROID_ABI AND NOT "${ANDROID_ABI}" STREQUAL "")
      set(_GEN_OPENAL_ANDROID_ABI "${ANDROID_ABI}")
    elseif(DEFINED GEN_ANDROID_ABI AND NOT "${GEN_ANDROID_ABI}" STREQUAL "")
      set(_GEN_OPENAL_ANDROID_ABI "${GEN_ANDROID_ABI}")
    else()
      set(_GEN_OPENAL_ANDROID_ABI "arm64-v8a")
    endif()

    set(_GEN_OPENAL_GENERATED_PLATFORM_DIR "${_GEN_OPENAL_GENERATED_DIR}/android/${_GEN_OPENAL_ANDROID_ABI}")

    set(HAVE_DLFCN_H                1)
    set(HAVE_PTHREAD_SETNAME_NP     1)
    set(HAVE_PTHREAD_SETSCHEDPARAM  1)

    set(HAVE_OPENSL                 1)
    set(HAVE_WAVE                   1)

    if(_GEN_OPENAL_ANDROID_ABI STREQUAL "x86")
      set(HAVE_SSE                  1)
      set(HAVE_SSE2                 1)
      set(HAVE_SSE3                 1)
      set(HAVE_SSE4_1               1)
      set(HAVE_SSE_INTRINSICS       1)
      set(ALSOFT_FORCE_ALIGN        "__attribute__((force_align_arg_pointer))")
    endif()

    if(_GEN_OPENAL_ANDROID_ABI STREQUAL "x86_64")
      set(HAVE_SSE                  1)
      set(HAVE_SSE2                 1)
      set(HAVE_SSE3                 1)
      set(HAVE_SSE4_1               1)
      set(HAVE_SSE_INTRINSICS       1)
    endif()

    if(_GEN_OPENAL_ANDROID_ABI STREQUAL "arm64-v8a")
      set(HAVE_NEON                 1)
    endif()

  endif()

  if("${_GEN_OPENAL_GENERATED_PLATFORM_DIR}" STREQUAL "")
    message(FATAL_ERROR "[ GEN OpenAL] Unsupported platform selection for OpenAL Soft 1.24.3")
  endif()

  file(MAKE_DIRECTORY "${_GEN_OPENAL_GENERATED_PLATFORM_DIR}")

  configure_file("${_GEN_OPENAL_TEMPLATES_DIR}/config.h.in"          "${_GEN_OPENAL_GENERATED_PLATFORM_DIR}/config.h"          @ONLY)
  configure_file("${_GEN_OPENAL_TEMPLATES_DIR}/config_backends.h.in" "${_GEN_OPENAL_GENERATED_PLATFORM_DIR}/config_backends.h" @ONLY)
  configure_file("${_GEN_OPENAL_TEMPLATES_DIR}/config_simd.h.in"     "${_GEN_OPENAL_GENERATED_PLATFORM_DIR}/config_simd.h"     @ONLY)
  configure_file("${_GEN_OPENAL_TEMPLATES_DIR}/version.h.in"         "${_GEN_OPENAL_GENERATED_PLATFORM_DIR}/version.h")

  list(PREPEND GEN_INCLUDES_DIR_LIST "${_GEN_OPENAL_TEMPLATES_DIR}/fmt-11.1.1/include")
  list(PREPEND GEN_INCLUDES_DIR_LIST "${_GEN_OPENAL_TEMPLATES_DIR}/common")
  list(PREPEND GEN_INCLUDES_DIR_LIST "${_GEN_OPENAL_GENERATED_PLATFORM_DIR}")

  set(GEN_TPL_SOURCES)

  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/auxeffectslot.cpp")    
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/buffer.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/debug.cpp")  
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/error.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/event.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/effect.cpp")   
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/extension.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/filter.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/listener.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/source.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/state.cpp")

  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/effects/autowah.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/effects/chorus.cpp")    
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/effects/compressor.cpp")   
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/effects/convolution.cpp")   
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/effects/dedicated.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/effects/distortion.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/effects/echo.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/effects/effects.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/effects/equalizer.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/effects/fshifter.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/effects/modulator.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/effects/null.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/effects/pshifter.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/effects/reverb.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/effects/vmorpher.cpp")

  if(COMPILE_FOR_WINDOWS)  

    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/eax/api.cpp")   
    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/eax/call.cpp")   
    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/eax/exception.cpp")    
    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/eax/fx_slot_index.cpp")    
    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/eax/fx_slots.cpp")
    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/al/eax/utils.cpp")

  endif()

  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/alc.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/alu.cpp")    
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/alconfig.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/context.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/device.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/events.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/panning.cpp")

  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/backends/base.cpp")    
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/backends/loopback.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/backends/null.cpp")

  if(COMPILE_FOR_WINDOWS)  

    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/backends/winmm.cpp")
    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/backends/dsound.cpp")
    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/backends/wasapi.cpp")
    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/backends/wave.cpp")

  endif()

  if(COMPILE_FOR_LINUX)  
  
    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/backends/alsa.cpp")	
    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/backends/oss.cpp")
    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/backends/pulseaudio.cpp")
    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/backends/wave.cpp")

  endif()

  if(COMPILE_FOR_ANDROID32 OR COMPILE_FOR_ANDROID64)   

    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/backends/opensl.cpp")
    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/backends/wave.cpp")

  endif()

  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/effects/autowah.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/effects/chorus.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/effects/compressor.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/effects/convolution.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/effects/dedicated.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/effects/distortion.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/effects/echo.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/effects/equalizer.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/effects/fshifter.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/effects/modulator.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/effects/null.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/effects/pshifter.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/effects/reverb.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/alc/effects/vmorpher.cpp")

  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/common/alassert.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/common/alcomplex.cpp") 
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/common/alsem.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/common/alstring.cpp")  
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/common/althrd_setname.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/common/dynload.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/common/filesystem.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/common/pffft.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/common/polyphase_resampler.cpp")      
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/common/ringbuffer.cpp")     
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/common/strutils.cpp")

  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/ambdec.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/ambidefs.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/bformatdec.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/bs2b.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/bsinc_tables.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/buffer_storage.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/context.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/converter.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/cpu_caps.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/cubic_tables.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/devformat.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/device.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/effectslot.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/except.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/filters/biquad.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/filters/nfc.cpp")   
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/filters/splitter.cpp")   
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/fpu_ctrl.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/helpers.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/hrtf.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/logging.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/mastering.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/mixer.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/storage_formats.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/uhjfilter.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/uiddefs.cpp")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/voice.cpp")

  if(COMPILE_FOR_LINUX)  

    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/dbus_wrap.cpp")
    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/rtkit.cpp")

  endif()

  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/mixer/mixer_c.cpp")

  if(COMPILE_FOR_WINDOWS OR COMPILE_FOR_LINUX_INTEL_64 OR _GEN_OPENAL_ANDROID_ABI STREQUAL "x86" OR _GEN_OPENAL_ANDROID_ABI STREQUAL "x86_64")

    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/mixer/mixer_sse.cpp")
    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/mixer/mixer_sse2.cpp")
    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/mixer/mixer_sse3.cpp")
    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/mixer/mixer_sse41.cpp")

  endif()

  if(COMPILE_FOR_LINUX_ARM        OR      
     COMPILE_FOR_LINUX_ARM_64     OR
     COMPILE_FOR_LINUX_ARM_RPI    OR 
     COMPILE_FOR_LINUX_ARM_RPI_64 OR
     _GEN_OPENAL_ANDROID_ABI STREQUAL "arm64-v8a")    

    list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_OPENAL}/core/mixer/mixer_neon.cpp")

  endif()  

  list(APPEND GEN_SOURCES_MODULES_LIST ${GEN_TPL_SOURCES})
  GEN_ThirdPartyLibraries_SuppressWarnings(OpenAL ${GEN_TPL_SOURCES})
      
endif()



if(THIRDPARTYLIBRARIES_DUKETAPE_FEATURE)

  list(APPEND GEN_THIRDPARTY_LIBRARYS DuckTape)

  set(GEN_TPL_SOURCES)
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_DUKTAPE}/duktape.c")

  list(APPEND GEN_SOURCES_MODULES_LIST ${GEN_TPL_SOURCES})
  GEN_ThirdPartyLibraries_SuppressWarnings(DuckTape ${GEN_TPL_SOURCES})

endif()



if(THIRDPARTYLIBRARIES_LUA_SCRIPT_FEATURE)

  #add_definitions(-DLUA_USE_POSIX)

  if(COMPILE_FOR_LINUX)

    add_definitions(-DLUA_USE_MKSTEMP)

  endif()

  list(APPEND GEN_THIRDPARTY_LIBRARYS LUA)

  set(GEN_TPL_SOURCES)
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/lapi.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/lauxlib.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/lbaselib.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/lbitlib.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/lcode.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/lcorolib.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/lctype.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/ldblib.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/ldebug.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/ldo.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/ldump.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/lfunc.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/lgc.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/linit.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/liolib.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/llex.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/lmathlib.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/lmem.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/loadlib.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/lobject.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/lopcodes.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/loslib.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/lparser.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/lstate.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/lstring.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/lstrlib.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/ltable.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/ltablib.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/ltm.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/lundump.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/lutf8lib.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/lvm.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_LUA}/lzio.c")

  list(APPEND GEN_SOURCES_MODULES_LIST ${GEN_TPL_SOURCES})
  GEN_ThirdPartyLibraries_SuppressWarnings(LUA ${GEN_TPL_SOURCES})

endif()


if(THIRDPARTYLIBRARIES_RPI5_WS281X_FEATURE)

  list(APPEND GEN_THIRDPARTY_LIBRARYS RPI_WS281X)

  set(GEN_TPL_SOURCES)
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_RPI_WS281X}/mailbox.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_RPI_WS281X}/ws2811.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_RPI_WS281X}/pwm.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_RPI_WS281X}/pcm.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_RPI_WS281X}/dma.c")
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_RPI_WS281X}/rpihw.c")

  list(APPEND GEN_SOURCES_MODULES_LIST ${GEN_TPL_SOURCES})
  GEN_ThirdPartyLibraries_SuppressWarnings(RPI_WS281X ${GEN_TPL_SOURCES})

endif()



if(GOOGLETEST_FEATURE)

  add_definitions(-DGOOGLETEST_ACTIVE)

  list(APPEND GEN_THIRDPARTY_LIBRARYS GoogleTest)

  # GoogleTest requires at least C++14
  set(CMAKE_CXX_STANDARD 14)

  enable_testing()
  include(GoogleTest)
  set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

  set(GEN_TPL_SOURCES)
  list(APPEND GEN_TPL_SOURCES "${GEN_DIRECTORY_THIRDPARTYLIBRARIES_GOOGLETEST_SOURCES}/gtest-all.cc")

  list(APPEND GEN_SOURCES_MODULES_LIST ${GEN_TPL_SOURCES})
  GEN_ThirdPartyLibraries_SuppressWarnings(GoogleTest ${GEN_TPL_SOURCES})

endif()
