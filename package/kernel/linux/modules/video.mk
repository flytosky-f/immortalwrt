#
# Copyright (C) 2009 David Cooper <dave@kupesoft.com>
# Copyright (C) 2006-2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

VIDEO_MENU:=Video Support

V4L2_DIR=v4l2-core
V4L2_USB_DIR=usb
V4L2_MEM2MEM_DIR=platform

#
# Media
#
define KernelPackage/media-controller
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Media Controller API
  KCONFIG:= \
	CONFIG_MEDIA_SUPPORT \
	CONFIG_MEDIA_CONTROLLER=y
  FILES:= \
	$(LINUX_DIR)/drivers/media/mc/mc.ko
  AUTOLOAD:=$(call AutoProbe,mc)
endef

define KernelPackage/media-controller/description
 Kernel modules for media controller API used to query media devices
 internal topology and configure it dynamically.
endef

$(eval $(call KernelPackage,media-controller))


#
# Video Display
#

define KernelPackage/acpi-video
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=ACPI Extensions For Display Adapters
  DEPENDS:=@TARGET_x86||TARGET_loongarch64 +kmod-backlight
  HIDDEN:=1
  KCONFIG:=CONFIG_ACPI_VIDEO
  FILES:=$(LINUX_DIR)/drivers/acpi/video.ko
  AUTOLOAD:=$(call AutoProbe,video)
endef

define KernelPackage/acpi-video/description
  Kernel support for integrated graphics devices.
endef

define KernelPackage/acpi-video/x86
  KCONFIG+=CONFIG_ACPI_WMI
  FILES+=$(LINUX_DIR)/drivers/platform/x86/wmi.ko
  AUTOLOAD:=$(call AutoProbe,wmi video)
endef

$(eval $(call KernelPackage,acpi-video))

define KernelPackage/backlight
	SUBMENU:=$(VIDEO_MENU)
	TITLE:=Backlight support
	DEPENDS:=@DISPLAY_SUPPORT +!LINUX_6_6:kmod-fb
	HIDDEN:=1
	KCONFIG:=CONFIG_BACKLIGHT_CLASS_DEVICE \
		CONFIG_BACKLIGHT_LCD_SUPPORT=y \
		CONFIG_LCD_CLASS_DEVICE=n \
		CONFIG_BACKLIGHT_GENERIC=n \
		CONFIG_BACKLIGHT_ADP8860=n \
		CONFIG_BACKLIGHT_ADP8870=n \
		CONFIG_BACKLIGHT_OT200=n \
		CONFIG_BACKLIGHT_PM8941_WLED=n
	FILES:=$(LINUX_DIR)/drivers/video/backlight/backlight.ko
	AUTOLOAD:=$(call AutoProbe,video backlight)
endef

define KernelPackage/backlight/description
	Kernel module for Backlight support.
endef

$(eval $(call KernelPackage,backlight))

define KernelPackage/backlight-pwm
	SUBMENU:=$(VIDEO_MENU)
	TITLE:=PWM Backlight support
	DEPENDS:=+kmod-backlight
	KCONFIG:=CONFIG_BACKLIGHT_PWM
	FILES:=$(LINUX_DIR)/drivers/video/backlight/pwm_bl.ko
	AUTOLOAD:=$(call AutoProbe,video pwm_bl)
endef

define KernelPackage/backlight-pwm/description
	Kernel module for PWM based Backlight support.
endef

$(eval $(call KernelPackage,backlight-pwm))


define KernelPackage/fb
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer and framebuffer console support
  DEPENDS:=@DISPLAY_SUPPORT +LINUX_6_6:kmod-fb-io-fops
  KCONFIG:= \
	CONFIG_FB \
	CONFIG_FB_DEVICE=y \
	CONFIG_FB_MXS=n \
	CONFIG_FB_SM750=n \
	CONFIG_FRAMEBUFFER_CONSOLE=y \
	CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y \
	CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y \
	CONFIG_FONTS=y \
	CONFIG_FONT_8x8=y \
	CONFIG_FONT_8x16=y \
	CONFIG_FONT_6x11=n \
	CONFIG_FONT_7x14=n \
	CONFIG_FONT_PEARL_8x8=n \
	CONFIG_FONT_ACORN_8x8=n \
	CONFIG_FONT_MINI_4x6=n \
	CONFIG_FONT_6x10=n \
	CONFIG_FONT_SUN8x16=n \
	CONFIG_FONT_SUN12x22=n \
	CONFIG_FONT_10x18=n \
	CONFIG_VT=y \
	CONFIG_CONSOLE_TRANSLATIONS=y \
	CONFIG_VT_CONSOLE=y \
	CONFIG_VT_HW_CONSOLE_BINDING=y
  FILES:=$(LINUX_DIR)/drivers/video/fbdev/core/fb.ko \
	$(LINUX_DIR)/lib/fonts/font.ko
  AUTOLOAD:=$(call AutoLoad,06,fb font)
endef

define KernelPackage/fb/description
 Kernel support for framebuffers and framebuffer console.
endef

define KernelPackage/fb/x86
  FILES+=$(LINUX_DIR)/arch/x86/video/fbdev.ko@lt6.12 \
	$(LINUX_DIR)/arch/x86/video/video-common.ko@ge6.12
  AUTOLOAD:=$(call AutoLoad,06,fbdev@lt6.12 video-common@ge6.12 fb font)
endef

$(eval $(call KernelPackage,fb))


define KernelPackage/fb-cfb-fillrect
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer software rectangle filling support
  DEPENDS:=+kmod-fb
  KCONFIG:=CONFIG_FB_CFB_FILLRECT
  FILES:=$(LINUX_DIR)/drivers/video/fbdev/core/cfbfillrect.ko
  AUTOLOAD:=$(call AutoLoad,07,cfbfillrect)
endef

define KernelPackage/fb-cfb-fillrect/description
 Kernel support for software rectangle filling
endef

$(eval $(call KernelPackage,fb-cfb-fillrect))


define KernelPackage/fb-cfb-copyarea
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer software copy area support
  DEPENDS:=+kmod-fb
  KCONFIG:=CONFIG_FB_CFB_COPYAREA
  FILES:=$(LINUX_DIR)/drivers/video/fbdev/core/cfbcopyarea.ko
  AUTOLOAD:=$(call AutoLoad,07,cfbcopyarea)
endef

define KernelPackage/fb-cfb-copyarea/description
 Kernel support for software copy area
endef

$(eval $(call KernelPackage,fb-cfb-copyarea))

define KernelPackage/fb-cfb-imgblt
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer software image blit support
  DEPENDS:=+kmod-fb
  KCONFIG:=CONFIG_FB_CFB_IMAGEBLIT
  FILES:=$(LINUX_DIR)/drivers/video/fbdev/core/cfbimgblt.ko
  AUTOLOAD:=$(call AutoLoad,07,cfbimgblt)
endef

define KernelPackage/fb-cfb-imgblt/description
 Kernel support for software image blitting
endef

$(eval $(call KernelPackage,fb-cfb-imgblt))


define KernelPackage/fb-io-fops
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Fbdev helpers for framebuffers in I/O memory
  HIDDEN:=1
  KCONFIG:=CONFIG_FB_IOMEM_FOPS
  FILES:=$(LINUX_DIR)/drivers/video/fbdev/core/fb_io_fops.ko
  AUTOLOAD:=$(call AutoLoad,07,fb_io_fops)
endef

$(eval $(call KernelPackage,fb-io-fops))


define KernelPackage/fb-sys-fops
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer software sys ops support
  DEPENDS:=+kmod-fb
  KCONFIG:= \
	CONFIG_FB_SYS_FOPS@lt6.12 \
	CONFIG_FB_SYSMEM_FOPS@ge6.12
  FILES:=$(LINUX_DIR)/drivers/video/fbdev/core/fb_sys_fops.ko
  AUTOLOAD:=$(call AutoLoad,07,fb_sys_fops)
endef

define KernelPackage/fb-sys-fops/description
 Kernel support for framebuffer sys ops
endef

$(eval $(call KernelPackage,fb-sys-fops))


define KernelPackage/fb-sys-ram
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer in system RAM support
  DEPENDS:=+kmod-fb
  KCONFIG:= \
	CONFIG_FB_SYS_COPYAREA \
	CONFIG_FB_SYS_FILLRECT \
	CONFIG_FB_SYS_IMAGEBLIT
  FILES:= \
	$(LINUX_DIR)/drivers/video/fbdev/core/syscopyarea.ko \
	$(LINUX_DIR)/drivers/video/fbdev/core/sysfillrect.ko \
	$(LINUX_DIR)/drivers/video/fbdev/core/sysimgblt.ko
  AUTOLOAD:=$(call AutoLoad,07,syscopyarea sysfillrect sysimgblt)
endef

define KernelPackage/fb-sys-ram/description
 Kernel support for framebuffers in system RAM
endef

$(eval $(call KernelPackage,fb-sys-ram))


define KernelPackage/fb-tft
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Support for small TFT LCD display modules
  DEPENDS:= \
	  @GPIO_SUPPORT +kmod-backlight \
	  +kmod-fb +kmod-fb-sys-fops +kmod-fb-sys-ram +kmod-spi-bitbang
  KCONFIG:= \
       CONFIG_FB_BACKLIGHT=y \
       CONFIG_FB_DEFERRED_IO=y \
       CONFIG_FB_TFT
  FILES:= \
       $(LINUX_DIR)/drivers/staging/fbtft/fbtft.ko
  AUTOLOAD:=$(call AutoLoad,08,fbtft)
endef

define KernelPackage/fb-tft/description
  Support for small TFT LCD display modules
endef

$(eval $(call KernelPackage,fb-tft))


define KernelPackage/fb-tft-ili9486
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=FB driver for the ILI9486 LCD Controller
  DEPENDS:=+kmod-fb-tft
  KCONFIG:=CONFIG_FB_TFT_ILI9486
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_ili9486.ko
  AUTOLOAD:=$(call AutoLoad,09,fb_ili9486)
endef

define KernelPackage/fb-tft-ili9486/description
  FB driver for the ILI9486 LCD Controller
endef

$(eval $(call KernelPackage,fb-tft-ili9486))


define KernelPackage/multimedia-input
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Multimedia input support
  DEPENDS:=+kmod-input-core
  KCONFIG:=CONFIG_RC_CORE \
	CONFIG_LIRC=y \
	CONFIG_RC_DECODERS=y \
	CONFIG_RC_DEVICES=y
  FILES:=$(LINUX_DIR)/drivers/media/rc/rc-core.ko
  AUTOLOAD:=$(call AutoProbe,rc-core)
endef

define KernelPackage/multimedia-input/description
  Enable multimedia input.
endef

$(eval $(call KernelPackage,multimedia-input))


define KernelPackage/drm
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Direct Rendering Manager (DRM) support
  HIDDEN:=1
  DEPENDS:=+kmod-dma-buf +kmod-i2c-core +PACKAGE_kmod-backlight:kmod-backlight \
	+kmod-fb
  KCONFIG:=CONFIG_DRM
  FILES:= \
	$(LINUX_DIR)/drivers/gpu/drm/drm.ko \
	$(LINUX_DIR)/drivers/gpu/drm/drm_panel_orientation_quirks.ko
  AUTOLOAD:=$(call AutoLoad,05,drm)
endef

define KernelPackage/drm/description
  Direct Rendering Manager (DRM) core support
endef

$(eval $(call KernelPackage,drm))


define KernelPackage/drm-buddy
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=A page based buddy allocator
  DEPENDS:=@DISPLAY_SUPPORT +kmod-drm
  KCONFIG:=CONFIG_DRM_BUDDY
  FILES:= $(LINUX_DIR)/drivers/gpu/drm/drm_buddy.ko
  AUTOLOAD:=$(call AutoProbe,drm_buddy)
endef

define KernelPackage/drm-buddy/description
  A page based buddy allocator
endef

$(eval $(call KernelPackage,drm-buddy))

define KernelPackage/drm-display-helper
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=DRM helpers for display adapters drivers
  DEPENDS:=@DISPLAY_SUPPORT +kmod-drm-kms-helper
  KCONFIG:=CONFIG_DRM_DISPLAY_HELPER
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/display/drm_display_helper.ko
  AUTOLOAD:=$(call AutoProbe,drm_display_helper)
endef

define KernelPackage/drm-display-helper/description
  DRM helpers for display adapters drivers.
endef

$(eval $(call KernelPackage,drm-display-helper))


define KernelPackage/drm-exec
  SUBMENU:=$(VIDEO_MENU)
  HIDDEN:=1
  TITLE:=Execution context for command submissions
  DEPENDS:=@DISPLAY_SUPPORT +kmod-drm
  KCONFIG:=CONFIG_DRM_EXEC
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/drm_exec.ko
  AUTOLOAD:=$(call AutoProbe,drm_exec)
endef

define KernelPackage/drm-exec/description
  Execution context for command submissions.
endef

$(eval $(call KernelPackage,drm-exec))


define KernelPackage/drm-gem-shmem-helper
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=GEM shmem helper functions
  DEPENDS:=@DISPLAY_SUPPORT +kmod-drm +!LINUX_6_6:kmod-drm-kms-helper \
	+!LINUX_6_6:kmod-fb-sys-fops +!LINUX_6_6:kmod-fb-sys-ram
  KCONFIG:=CONFIG_DRM_GEM_SHMEM_HELPER
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/drm_shmem_helper.ko
  AUTOLOAD:=$(call AutoProbe,drm_shmem_helper)
endef

$(eval $(call KernelPackage,drm-gem-shmem-helper))


define KernelPackage/drm-dma-helper
  SUBMENU:=$(VIDEO_MENU)
  HIDDEN:=1
  TITLE:=GEM DMA helper functions
  DEPENDS:=@DISPLAY_SUPPORT +kmod-drm-kms-helper
  KCONFIG:=CONFIG_DRM_GEM_DMA_HELPER
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/drm_dma_helper.ko
  AUTOLOAD:=$(call AutoProbe,drm_dma_helper)
endef

define KernelPackage/drm-dma-helper/description
  GEM DMA helper functions.
endef

$(eval $(call KernelPackage,drm-dma-helper))

define KernelPackage/drm-mipi-dbi
  SUBMENU:=$(VIDEO_MENU)
  HIDDEN:=1
  TITLE:=MIPI DBI helpers
  DEPENDS:=@DISPLAY_SUPPORT +kmod-backlight +kmod-drm-kms-helper
  KCONFIG:=CONFIG_DRM_MIPI_DBI
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/drm_mipi_dbi.ko
  AUTOLOAD:=$(call AutoProbe,drm_mipi_dbi)
endef

define KernelPackage/drm-mipi-dbi/description
  MIPI Display Bus Interface (DBI) LCD controller support.
endef

$(eval $(call KernelPackage,drm-mipi-dbi))

define KernelPackage/drm-ttm
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=GPU memory management subsystem
  DEPENDS:=@DISPLAY_SUPPORT +kmod-drm
  KCONFIG:=CONFIG_DRM_TTM
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/ttm/ttm.ko
  AUTOLOAD:=$(call AutoProbe,ttm)
endef

define KernelPackage/drm-ttm/description
  GPU memory management subsystem for devices with multiple GPU memory types.
  Will be enabled automatically if a device driver uses it.
endef

$(eval $(call KernelPackage,drm-ttm))


define KernelPackage/drm-ttm-helper
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Helpers for ttm-based gem objects
  HIDDEN:=1
  DEPENDS:=@DISPLAY_SUPPORT +kmod-drm-ttm +!LINUX_6_6:kmod-drm-kms-helper
  KCONFIG:=CONFIG_DRM_TTM_HELPER
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/drm_ttm_helper.ko
  AUTOLOAD:=$(call AutoProbe,drm_ttm_helper)
endef

$(eval $(call KernelPackage,drm-ttm-helper))


define KernelPackage/drm-kms-helper
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=CRTC helpers for KMS drivers
  DEPENDS:=@DISPLAY_SUPPORT +kmod-drm +kmod-fb +kmod-fb-sys-fops +kmod-fb-cfb-copyarea \
	+kmod-fb-cfb-fillrect +kmod-fb-cfb-imgblt +kmod-fb-sys-ram
  KCONFIG:= \
    CONFIG_DRM_KMS_HELPER \
    CONFIG_DRM_KMS_FB_HELPER=y
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/drm_kms_helper.ko
  AUTOLOAD:=$(call AutoProbe,drm_kms_helper)
endef

define KernelPackage/drm-kms-helper/description
  CRTC helpers for KMS drivers.
endef

$(eval $(call KernelPackage,drm-kms-helper))

define KernelPackage/drm-suballoc-helper
  SUBMENU:=$(VIDEO_MENU)
  HIDDEN:=1
  TITLE:=DRM suballocation helper
  DEPENDS:=@DISPLAY_SUPPORT +kmod-drm
  KCONFIG:=CONFIG_DRM_SUBALLOC_HELPER
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/drm_suballoc_helper.ko
  AUTOLOAD:=$(call AutoProbe,drm_suballoc_helper)
endef

define KernelPackage/drm-suballoc-helper/description
  DRM suballocation helper.
endef

$(eval $(call KernelPackage,drm-suballoc-helper))

define KernelPackage/drm-vram-helper
  SUBMENU:=$(VIDEO_MENU)
  HIDDEN:=1
  TITLE:=DRM helpers for VRAM memory management
  DEPENDS:=@DISPLAY_SUPPORT \
    +kmod-drm-kms-helper +kmod-drm-ttm-helper
  KCONFIG:=CONFIG_DRM_VRAM_HELPER
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/drm_vram_helper.ko
  AUTOLOAD:=$(call AutoProbe,drm_vram_helper)
endef

define KernelPackage/drm-vram-helper/description
  DRM helpers for VRAM memory management.
endef

$(eval $(call KernelPackage,drm-vram-helper))

define KernelPackage/drm-amdgpu
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=AMDGPU DRM support
  DEPENDS:=@TARGET_x86||TARGET_loongarch64 @DISPLAY_SUPPORT +kmod-backlight +kmod-drm-ttm \
	+kmod-drm-ttm-helper +kmod-drm-kms-helper +kmod-i2c-algo-bit +amdgpu-firmware \
	+kmod-drm-display-helper +kmod-drm-buddy +kmod-acpi-video \
	+kmod-drm-exec +kmod-drm-suballoc-helper
  KCONFIG:=CONFIG_DRM_AMDGPU \
	CONFIG_DRM_AMDGPU_SI=y \
	CONFIG_DRM_AMDGPU_CIK=y \
	CONFIG_DRM_AMD_DC=y \
	CONFIG_DEBUG_KERNEL_DC=n
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/amd/amdgpu/amdgpu.ko \
	$(LINUX_DIR)/drivers/gpu/drm/scheduler/gpu-sched.ko \
	$(LINUX_DIR)/drivers/gpu/drm/amd/amdxcp/amdxcp.ko
  AUTOLOAD:=$(call AutoProbe,amdgpu)
endef

define KernelPackage/drm-amdgpu/description
  Direct Rendering Manager (DRM) support for AMDGPU Cards
endef

define KernelPackage/drm-amdgpu/loongarch64
  KCONFIG+=CONFIG_DRM_AMDGPU_USERPTR=y \
	CONFIG_DRM_AMD_DC=y \
	CONFIG_DRM_AMD_DC_FP=y \
	CONFIG_DRM_AMD_DC_SI=y
endef

$(eval $(call KernelPackage,drm-amdgpu))

define KernelPackage/drm-i915
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Intel i915 DRM support
  DEPENDS:=@(TARGET_x86_64||TARGET_x86_generic||TARGET_x86_legacy) \
	@DISPLAY_SUPPORT +kmod-backlight +kmod-drm-ttm \
	+kmod-drm-ttm-helper +kmod-drm-kms-helper +kmod-i2c-algo-bit +i915-firmware-dmc \
	+kmod-drm-display-helper +kmod-drm-buddy +kmod-acpi-video \
	+kmod-drm-exec +kmod-drm-suballoc-helper
  KCONFIG:=CONFIG_DRM_I915 \
	CONFIG_DRM_I915_CAPTURE_ERROR=y \
	CONFIG_DRM_I915_COMPRESS_ERROR=y \
	CONFIG_DRM_I915_DEBUG=n \
	CONFIG_DRM_I915_DEBUG_GUC=n \
	CONFIG_DRM_I915_DEBUG_MMIO=n \
	CONFIG_DRM_I915_DEBUG_RUNTIME_PM=n \
	CONFIG_DRM_I915_DEBUG_VBLANK_EVADE=n \
	CONFIG_DRM_I915_FENCE_TIMEOUT=10000 \
	CONFIG_DRM_I915_FORCE_PROBE="" \
	CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500 \
	CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS=n \
	CONFIG_DRM_I915_MAX_REQUEST_BUSYWAIT=8000 \
	CONFIG_DRM_I915_PREEMPT_TIMEOUT=640 \
	CONFIG_DRM_I915_PREEMPT_TIMEOUT_COMPUTE=7500 \
	CONFIG_DRM_I915_REQUEST_TIMEOUT=20000 \
	CONFIG_DRM_I915_SELFTEST=n \
	CONFIG_DRM_I915_STOP_TIMEOUT=100 \
	CONFIG_DRM_I915_SW_FENCE_CHECK_DAG=n \
	CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS=n \
	CONFIG_DRM_I915_TIMESLICE_DURATION=1 \
	CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250 \
	CONFIG_DRM_I915_USERPTR=y \
	CONFIG_DRM_I915_WERROR=n \
	CONFIG_FB_INTEL=n
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/i915/i915.ko
  AUTOLOAD:=$(call AutoProbe,i915)
endef

define KernelPackage/drm-i915/description
  Direct Rendering Manager (DRM) support for Intel GPU
endef

$(eval $(call KernelPackage,drm-i915))

define KernelPackage/drm-ivpu
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Intel VPU DRM support
  DEPENDS:=@TARGET_x86_64 +ivpu-firmware
  KCONFIG:=CONFIG_DRM_ACCEL_IVPU
  FILES:=$(LINUX_DIR)/drivers/accel/ivpu/intel_vpu.ko
  AUTOLOAD:=$(call AutoProbe,intel_vpu)
endef

define KernelPackage/drm-ivpu/description
  Direct Rendering Manager (DRM) support for Intel VPU
endef

$(eval $(call KernelPackage,drm-ivpu))

define KernelPackage/drm-imx
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Freescale i.MX DRM support
  DEPENDS:=@TARGET_imx +kmod-drm-kms-helper
  KCONFIG:=CONFIG_DRM_IMX \
	CONFIG_DRM_FBDEV_EMULATION=y \
	CONFIG_DRM_FBDEV_OVERALLOC=100 \
	CONFIG_IMX_IPUV3_CORE \
	CONFIG_RESET_CONTROLLER=y \
	CONFIG_DRM_IMX_IPUV3 \
	CONFIG_IMX_IPUV3 \
	CONFIG_DRM_GEM_CMA_HELPER=y \
	CONFIG_DRM_KMS_CMA_HELPER=y \
	CONFIG_DRM_IMX_FB_HELPER \
	CONFIG_DRM_IMX_PARALLEL_DISPLAY=n \
	CONFIG_DRM_IMX_TVE=n \
	CONFIG_DRM_IMX_LDB=n \
	CONFIG_DRM_IMX_HDMI=n
  FILES:= \
	$(LINUX_DIR)/drivers/gpu/drm/imx/ipuv3/imxdrm.ko \
	$(LINUX_DIR)/drivers/gpu/drm/drm_dma_helper.ko \
	$(LINUX_DIR)/drivers/gpu/ipu-v3/imx-ipu-v3.ko
  AUTOLOAD:=$(call AutoLoad,08,imxdrm imx-ipu-v3 imx-ipuv3-crtc)
endef

define KernelPackage/drm-imx/description
  Direct Rendering Manager (DRM) support for Freescale i.MX
endef

$(eval $(call KernelPackage,drm-imx))

define KernelPackage/drm-imx-hdmi
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Freescale i.MX HDMI DRM support
  DEPENDS:=+kmod-sound-core kmod-drm-imx kmod-drm-display-helper
  KCONFIG:=CONFIG_DRM_IMX_HDMI \
	CONFIG_DRM_DW_HDMI_AHB_AUDIO \
	CONFIG_DRM_DW_HDMI_I2S_AUDIO
  FILES:= \
	$(LINUX_DIR)/drivers/gpu/drm/bridge/synopsys/dw-hdmi.ko \
	$(LINUX_DIR)/drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.ko \
	$(LINUX_DIR)/drivers/gpu/drm/imx/ipuv3/dw_hdmi-imx.ko
  AUTOLOAD:=$(call AutoLoad,08,dw-hdmi dw-hdmi-ahb-audio.ko dw_hdmi-imx)
endef

define KernelPackage/drm-imx-hdmi/description
  Direct Rendering Manager (DRM) support for Freescale i.MX HDMI
endef

$(eval $(call KernelPackage,drm-imx-hdmi))


define KernelPackage/drm-imx-ldb
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Freescale i.MX LVDS DRM support
  DEPENDS:=@(TARGET_imx&&TARGET_imx_cortexa9) +kmod-backlight +kmod-drm-panel-simple kmod-drm-imx
  KCONFIG:=CONFIG_DRM_IMX_LDB \
	CONFIG_DRM_PANEL_SAMSUNG_LD9040=n \
	CONFIG_DRM_PANEL_SAMSUNG_S6E8AA0=n \
	CONFIG_DRM_PANEL_LG_LG4573=n \
	CONFIG_DRM_PANEL_LD9040=n \
	CONFIG_DRM_PANEL_LVDS=n \
	CONFIG_DRM_PANEL_S6E8AA0=n \
	CONFIG_DRM_PANEL_SITRONIX_ST7789V=n
  FILES:= \
	$(LINUX_DIR)/drivers/gpu/drm/imx/ipuv3/imx-ldb.ko
  AUTOLOAD:=$(call AutoLoad,08,imx-ldb)
endef

define KernelPackage/drm-imx-ldb/description
  Direct Rendering Manager (DRM) support for Freescale i.MX LVDS
endef

$(eval $(call KernelPackage,drm-imx-ldb))

define KernelPackage/drm-lima
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Mali-4xx GPU support
  DEPENDS:=@(TARGET_rockchip||TARGET_sunxi) +kmod-drm +kmod-drm-gem-shmem-helper
  KCONFIG:= \
	CONFIG_DRM_VGEM \
	CONFIG_DRM_GEM_CMA_HELPER=y \
	CONFIG_DRM_LIMA
  FILES:= \
	$(LINUX_DIR)/drivers/gpu/drm/vgem/vgem.ko \
	$(LINUX_DIR)/drivers/gpu/drm/scheduler/gpu-sched.ko \
	$(LINUX_DIR)/drivers/gpu/drm/lima/lima.ko
  AUTOLOAD:=$(call AutoProbe,lima vgem)
endef

define KernelPackage/drm-lima/description
  Open-source reverse-engineered driver for Mali-4xx GPUs
endef

$(eval $(call KernelPackage,drm-lima))

define KernelPackage/drm-panfrost
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=DRM support for ARM Mali Midgard/Bifrost GPUs
  DEPENDS:=@(TARGET_rockchip||TARGET_sunxi) +kmod-drm +kmod-drm-gem-shmem-helper
  KCONFIG:=CONFIG_DRM_PANFROST
  FILES:= \
	$(LINUX_DIR)/drivers/gpu/drm/panfrost/panfrost.ko \
	$(LINUX_DIR)/drivers/gpu/drm/scheduler/gpu-sched.ko
  AUTOLOAD:=$(call AutoProbe,panfrost)
endef

define KernelPackage/drm-panfrost/description
  DRM driver for ARM Mali Midgard (T6xx, T7xx, T8xx) and
  Bifrost (G3x, G5x, G7x) GPUs
endef

$(eval $(call KernelPackage,drm-panfrost))

define KernelPackage/drm-panthor
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=DRM support for ARM Mali CSF-based GPUs
  DEPENDS:=@TARGET_rockchip +kmod-drm +kmod-drm-exec \
	+kmod-drm-gem-shmem-helper +panthor-firmware
  KCONFIG:= \
	CONFIG_DRM_GPUVM \
	CONFIG_DRM_PANTHOR
  FILES:= \
	$(LINUX_DIR)/drivers/gpu/drm/drm_gpuvm.ko \
	$(LINUX_DIR)/drivers/gpu/drm/panthor/panthor.ko \
	$(LINUX_DIR)/drivers/gpu/drm/scheduler/gpu-sched.ko
  AUTOLOAD:=$(call AutoProbe,panthor)
endef

define KernelPackage/drm-panthor/description
  DRM driver for ARM Mali Mali (or Immortalis) Valhall Gxxx GPUs
endef

$(eval $(call KernelPackage,drm-panthor))

define KernelPackage/drm-panel-mipi-dbi
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Generic MIPI DBI LCD panel
  DEPENDS:=+kmod-drm-mipi-dbi +kmod-drm-dma-helper
  KCONFIG:=CONFIG_DRM_PANEL_MIPI_DBI \
	CONFIG_DRM_FBDEV_EMULATION=y \
	CONFIG_DRM_FBDEV_OVERALLOC=100
  FILES:= \
	$(LINUX_DIR)/drivers/gpu/drm/tiny/panel-mipi-dbi.ko
  AUTOLOAD:=$(call AutoProbe,panel-mipi-dbi)
endef

define KernelPackage/drm-panel-mipi-dbi/description
  Generic driver for MIPI Alliance Display Bus Interface
endef

$(eval $(call KernelPackage,drm-panel-mipi-dbi))


define KernelPackage/drm-panel-simple
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Simple (non-eDP) TFT panels
  DEPENDS:=@USES_DEVICETREE @USES_PM +kmod-drm +kmod-backlight
  KCONFIG:=CONFIG_DRM_PANEL_SIMPLE \
	CONFIG_DRM_PANEL=y
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/panel/panel-simple.ko
  AUTOLOAD:=$(call AutoProbe,panel-simple)
endef

define KernelPackage/drm-panel-simple/description
  Generic driver for simple raw (ie. non-eDP) TFT panels.
endef

$(eval $(call KernelPackage,drm-panel-simple))


define KernelPackage/drm-panel-tc358762
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=TC358762 DSI/DPI bridge
  DEPENDS:=+kmod-drm-kms-helper
  KCONFIG:=CONFIG_DRM_TOSHIBA_TC358762 \
	CONFIG_DRM_BRIDGE=y \
	CONFIG_DRM_MIPI_DSI=y \
	CONFIG_DRM_PANEL=y
	CONFIG_DRM_PANEL_BRIDGE=y
  FILES:= \
	$(LINUX_DIR)/drivers/gpu/drm/bridge/tc358762.ko
  AUTOLOAD:=$(call AutoProbe,tc358762)
endef

define KernelPackage/drm-panel-tc358762/description
 Toshiba TC358762 DSI/DPI bridge driver
endef

$(eval $(call KernelPackage,drm-panel-tc358762))


define KernelPackage/drm-radeon
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Radeon DRM support
  DEPENDS:=@TARGET_x86 @DISPLAY_SUPPORT +kmod-backlight +kmod-drm-kms-helper \
	+kmod-drm-ttm +kmod-drm-ttm-helper +kmod-i2c-algo-bit +radeon-firmware \
	+kmod-drm-display-helper +kmod-acpi-video +kmod-drm-suballoc-helper \
	+!LINUX_6_6:kmod-fb-io-fops
  KCONFIG:=CONFIG_DRM_RADEON
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/radeon/radeon.ko
  AUTOLOAD:=$(call AutoProbe,radeon)
endef

define KernelPackage/drm-radeon/description
  Direct Rendering Manager (DRM) support for Radeon Cards
endef

$(eval $(call KernelPackage,drm-radeon))

#
# Video Capture
#

define KernelPackage/video-core
  SUBMENU:=$(VIDEO_MENU)
  TITLE=Video4Linux support
  DEPENDS:=+PACKAGE_kmod-i2c-core:kmod-i2c-core +kmod-media-controller
  KCONFIG:= \
	CONFIG_MEDIA_CAMERA_SUPPORT=y \
	CONFIG_VIDEO_DEV \
	CONFIG_V4L_PLATFORM_DRIVERS=y \
	CONFIG_MEDIA_PLATFORM_DRIVERS=y
  FILES:= \
	$(LINUX_DIR)/drivers/media/$(V4L2_DIR)/videodev.ko
  AUTOLOAD:=$(call AutoLoad,60,videodev)
endef

define KernelPackage/video-core/description
 Kernel modules for Video4Linux support
endef

$(eval $(call KernelPackage,video-core))


define AddDepends/video
  SUBMENU:=$(VIDEO_MENU)
  DEPENDS+=kmod-video-core $(1)
endef

define AddDepends/camera
$(AddDepends/video)
  KCONFIG+=CONFIG_MEDIA_USB_SUPPORT=y \
	 CONFIG_MEDIA_CAMERA_SUPPORT=y
endef

define AddDepends/framegrabber
$(AddDepends/video)
  KCONFIG+=CONFIG_MEDIA_PCI_SUPPORT=y
endef

define KernelPackage/video-videobuf2
  TITLE:=videobuf2 lib
  DEPENDS:=+kmod-dma-buf
  KCONFIG:= \
	CONFIG_VIDEOBUF2_CORE \
	CONFIG_VIDEOBUF2_MEMOPS \
	CONFIG_VIDEOBUF2_V4L2 \
	CONFIG_VIDEOBUF2_VMALLOC
  FILES:= \
	$(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-common.ko \
	$(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-v4l2.ko \
	$(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-memops.ko \
	$(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-vmalloc.ko
  AUTOLOAD:=$(call AutoLoad,65,videobuf2-core videobuf-v4l2 videobuf2-memops videobuf2-vmalloc)
  $(call AddDepends/video)
endef

define KernelPackage/video-videobuf2/description
 Kernel modules that implements three basic types of media buffers.
endef

$(eval $(call KernelPackage,video-videobuf2))

define KernelPackage/video-async
  TITLE:=V4L2 ASYNC support
  KCONFIG:=CONFIG_V4L2_ASYNC
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_DIR)/v4l2-async.ko
  $(call AddDepends/video)
  AUTOLOAD:=$(call AutoProbe,v4l2-async)
endef

$(eval $(call KernelPackage,video-async))

define KernelPackage/video-fwnode
  TITLE:=V4L2 FWNODE support
  KCONFIG:=CONFIG_V4L2_FWNODE
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_DIR)/v4l2-fwnode.ko
  $(call AddDepends/video,+kmod-video-async)
  AUTOLOAD:=$(call AutoProbe,v4l2-fwnode)
endef

$(eval $(call KernelPackage,video-fwnode))

define KernelPackage/video-cpia2
  TITLE:=CPIA2 video driver
  DEPENDS:=@USB_SUPPORT
  KCONFIG:=CONFIG_VIDEO_CPIA2
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/cpia2/cpia2.ko
  AUTOLOAD:=$(call AutoProbe,cpia2)
  $(call AddDepends/camera)
endef

define KernelPackage/video-cpia2/description
 Kernel modules for supporting CPIA2 USB based cameras
endef

$(eval $(call KernelPackage,video-cpia2))


define KernelPackage/video-pwc
  TITLE:=Philips USB webcam support
  DEPENDS:=@USB_SUPPORT +kmod-usb-core +kmod-video-videobuf2
  KCONFIG:= \
	CONFIG_USB_PWC \
	CONFIG_USB_PWC_DEBUG=n
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/pwc/pwc.ko
  AUTOLOAD:=$(call AutoProbe,pwc)
  $(call AddDepends/camera)
endef

define KernelPackage/video-pwc/description
 Kernel modules for supporting Philips USB based cameras
endef

$(eval $(call KernelPackage,video-pwc))


define KernelPackage/video-uvc
  TITLE:=USB Video Class (UVC) support
  DEPENDS:=@USB_SUPPORT +kmod-usb-core +kmod-video-videobuf2 +kmod-input-core
  KCONFIG:= CONFIG_USB_VIDEO_CLASS CONFIG_UVC_COMMON
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/uvc/uvcvideo.ko \
	$(LINUX_DIR)/drivers/media/common/uvc.ko
  AUTOLOAD:=$(call AutoProbe,uvc uvcvideo)
  $(call AddDepends/camera)
endef

define KernelPackage/video-uvc/description
 Kernel modules for supporting USB Video Class (UVC) devices
endef

$(eval $(call KernelPackage,video-uvc))


define KernelPackage/video-gspca-core
  MENU:=1
  TITLE:=GSPCA webcam core support framework
  DEPENDS:=@USB_SUPPORT +kmod-usb-core +kmod-input-core +kmod-video-videobuf2
  KCONFIG:=CONFIG_USB_GSPCA
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_main.ko
  AUTOLOAD:=$(call AutoProbe,gspca_main)
  $(call AddDepends/camera)
endef

define KernelPackage/video-gspca-core/description
 Kernel modules for supporting GSPCA based webcam devices. Note this is just
 the core of the driver, please select a submodule that supports your webcam.
endef

$(eval $(call KernelPackage,video-gspca-core))


define AddDepends/camera-gspca
  SUBMENU:=$(VIDEO_MENU)
  DEPENDS+=kmod-video-gspca-core $(1)
endef


define KernelPackage/video-gspca-conex
  TITLE:=conex webcam support
  KCONFIG:=CONFIG_USB_GSPCA_CONEX
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_conex.ko
  AUTOLOAD:=$(call AutoProbe,gspca_conex)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-conex/description
 The Conexant Camera Driver (conex) kernel module
endef

$(eval $(call KernelPackage,video-gspca-conex))


define KernelPackage/video-gspca-etoms
  TITLE:=etoms webcam support
  KCONFIG:=CONFIG_USB_GSPCA_ETOMS
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_etoms.ko
  AUTOLOAD:=$(call AutoProbe,gspca_etoms)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-etoms/description
 The Etoms USB Camera Driver (etoms) kernel module
endef

$(eval $(call KernelPackage,video-gspca-etoms))


define KernelPackage/video-gspca-finepix
  TITLE:=finepix webcam support
  KCONFIG:=CONFIG_USB_GSPCA_FINEPIX
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_finepix.ko
  AUTOLOAD:=$(call AutoProbe,gspca_finepix)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-finepix/description
 The Fujifilm FinePix USB V4L2 driver (finepix) kernel module
endef

$(eval $(call KernelPackage,video-gspca-finepix))


define KernelPackage/video-gspca-mars
  TITLE:=mars webcam support
  KCONFIG:=CONFIG_USB_GSPCA_MARS
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_mars.ko
  AUTOLOAD:=$(call AutoProbe,gspca_mars)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-mars/description
 The Mars USB Camera Driver (mars) kernel module
endef

$(eval $(call KernelPackage,video-gspca-mars))


define KernelPackage/video-gspca-mr97310a
  TITLE:=mr97310a webcam support
  KCONFIG:=CONFIG_USB_GSPCA_MR97310A
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_mr97310a.ko
  AUTOLOAD:=$(call AutoProbe,gspca_mr97310a)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-mr97310a/description
 The Mars-Semi MR97310A USB Camera Driver (mr97310a) kernel module
endef

$(eval $(call KernelPackage,video-gspca-mr97310a))


define KernelPackage/video-gspca-ov519
  TITLE:=ov519 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_OV519
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_ov519.ko
  AUTOLOAD:=$(call AutoProbe,gspca_ov519)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-ov519/description
 The OV519 USB Camera Driver (ov519) kernel module
endef

$(eval $(call KernelPackage,video-gspca-ov519))


define KernelPackage/video-gspca-ov534
  TITLE:=ov534 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_OV534
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_ov534.ko
  AUTOLOAD:=$(call AutoProbe,gspca_ov534)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-ov534/description
 The OV534 USB Camera Driver (ov534) kernel module
endef

$(eval $(call KernelPackage,video-gspca-ov534))


define KernelPackage/video-gspca-ov534-9
  TITLE:=ov534-9 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_OV534_9
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_ov534_9.ko
  AUTOLOAD:=$(call AutoProbe,gspca_ov534_9)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-ov534-9/description
 The OV534-9 USB Camera Driver (ov534_9) kernel module
endef

$(eval $(call KernelPackage,video-gspca-ov534-9))


define KernelPackage/video-gspca-pac207
  TITLE:=pac207 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_PAC207
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_pac207.ko
  AUTOLOAD:=$(call AutoProbe,gspca_pac207)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-pac207/description
 The Pixart PAC207 USB Camera Driver (pac207) kernel module
endef

$(eval $(call KernelPackage,video-gspca-pac207))


define KernelPackage/video-gspca-pac7302
  TITLE:=pac7302 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_PAC7302
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_pac7302.ko
  AUTOLOAD:=$(call AutoProbe,gspca_pac7302)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-pac7302/description
 The Pixart PAC7302 USB Camera Driver (pac7302) kernel module
endef

$(eval $(call KernelPackage,video-gspca-pac7302))


define KernelPackage/video-gspca-pac7311
  TITLE:=pac7311 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_PAC7311
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_pac7311.ko
  AUTOLOAD:=$(call AutoProbe,gspca_pac7311)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-pac7311/description
 The Pixart PAC7311 USB Camera Driver (pac7311) kernel module
endef

$(eval $(call KernelPackage,video-gspca-pac7311))


define KernelPackage/video-gspca-se401
  TITLE:=se401 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SE401
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_se401.ko
  AUTOLOAD:=$(call AutoProbe,gspca_se401)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-se401/description
 The SE401 USB Camera Driver kernel module
endef

$(eval $(call KernelPackage,video-gspca-se401))


define KernelPackage/video-gspca-sn9c20x
  TITLE:=sn9c20x webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SN9C20X
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sn9c20x.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sn9c20x)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sn9c20x/description
 The SN9C20X USB Camera Driver (sn9c20x) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sn9c20x))


define KernelPackage/video-gspca-sonixb
  TITLE:=sonixb webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SONIXB
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sonixb.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sonixb)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sonixb/description
 The SONIX Bayer USB Camera Driver (sonixb) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sonixb))


define KernelPackage/video-gspca-sonixj
  TITLE:=sonixj webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SONIXJ
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sonixj.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sonixj)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sonixj/description
 The SONIX JPEG USB Camera Driver (sonixj) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sonixj))


define KernelPackage/video-gspca-spca500
  TITLE:=spca500 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA500
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca500.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca500)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca500/description
 The SPCA500 USB Camera Driver (spca500) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca500))


define KernelPackage/video-gspca-spca501
  TITLE:=spca501 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA501
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca501.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca501)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca501/description
 The SPCA501 USB Camera Driver (spca501) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca501))


define KernelPackage/video-gspca-spca505
  TITLE:=spca505 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA505
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca505.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca505)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca505/description
 The SPCA505 USB Camera Driver (spca505) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca505))


define KernelPackage/video-gspca-spca506
  TITLE:=spca506 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA506
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca506.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca506)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca506/description
 The SPCA506 USB Camera Driver (spca506) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca506))


define KernelPackage/video-gspca-spca508
  TITLE:=spca508 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA508
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca508.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca508)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca508/description
 The SPCA508 USB Camera Driver (spca508) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca508))


define KernelPackage/video-gspca-spca561
  TITLE:=spca561 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA561
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca561.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca561)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca561/description
 The SPCA561 USB Camera Driver (spca561) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca561))


define KernelPackage/video-gspca-sq905
  TITLE:=sq905 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SQ905
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sq905.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sq905)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sq905/description
 The SQ Technologies SQ905 based USB Camera Driver (sq905) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sq905))


define KernelPackage/video-gspca-sq905c
  TITLE:=sq905c webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SQ905C
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sq905c.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sq905c)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sq905c/description
 The SQ Technologies SQ905C based USB Camera Driver (sq905c) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sq905c))


define KernelPackage/video-gspca-sq930x
  TITLE:=sq930x webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SQ930X
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sq930x.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sq930x)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sq930x/description
 The SQ Technologies SQ930X based USB Camera Driver (sq930x) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sq930x))


define KernelPackage/video-gspca-stk014
  TITLE:=stk014 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_STK014
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_stk014.ko
  AUTOLOAD:=$(call AutoProbe,gspca_stk014)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-stk014/description
 The Syntek DV4000 (STK014) USB Camera Driver (stk014) kernel module
endef

$(eval $(call KernelPackage,video-gspca-stk014))


define KernelPackage/video-gspca-sunplus
  TITLE:=sunplus webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SUNPLUS
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sunplus.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sunplus)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sunplus/description
 The SUNPLUS USB Camera Driver (sunplus) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sunplus))


define KernelPackage/video-gspca-t613
  TITLE:=t613 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_T613
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_t613.ko
  AUTOLOAD:=$(call AutoProbe,gspca_t613)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-t613/description
 The T613 (JPEG Compliance) USB Camera Driver (t613) kernel module
endef

$(eval $(call KernelPackage,video-gspca-t613))


define KernelPackage/video-gspca-tv8532
  TITLE:=tv8532 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_TV8532
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_tv8532.ko
  AUTOLOAD:=$(call AutoProbe,gspca_tv8532)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-tv8532/description
 The TV8532 USB Camera Driver (tv8532) kernel module
endef

$(eval $(call KernelPackage,video-gspca-tv8532))


define KernelPackage/video-gspca-vc032x
  TITLE:=vc032x webcam support
  KCONFIG:=CONFIG_USB_GSPCA_VC032X
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_vc032x.ko
  AUTOLOAD:=$(call AutoProbe,gspca_vc032x)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-vc032x/description
 The VC032X USB Camera Driver (vc032x) kernel module
endef

$(eval $(call KernelPackage,video-gspca-vc032x))


define KernelPackage/video-gspca-zc3xx
  TITLE:=zc3xx webcam support
  KCONFIG:=CONFIG_USB_GSPCA_ZC3XX
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_zc3xx.ko
  AUTOLOAD:=$(call AutoProbe,gspca_zc3xx)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-zc3xx/description
 The ZC3XX USB Camera Driver (zc3xx) kernel module
endef

$(eval $(call KernelPackage,video-gspca-zc3xx))


define KernelPackage/video-gspca-m5602
  TITLE:=m5602 webcam support
  KCONFIG:=CONFIG_USB_M5602
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/m5602/gspca_m5602.ko
  AUTOLOAD:=$(call AutoProbe,gspca_m5602)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-m5602/description
 The ALi USB m5602 Camera Driver (m5602) kernel module
endef

$(eval $(call KernelPackage,video-gspca-m5602))


define KernelPackage/video-gspca-stv06xx
  TITLE:=stv06xx webcam support
  KCONFIG:=CONFIG_USB_STV06XX
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/stv06xx/gspca_stv06xx.ko
  AUTOLOAD:=$(call AutoProbe,gspca_stv06xx)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-stv06xx/description
 The STV06XX USB Camera Driver (stv06xx) kernel module
endef

$(eval $(call KernelPackage,video-gspca-stv06xx))


define KernelPackage/video-gspca-gl860
  TITLE:=gl860 webcam support
  KCONFIG:=CONFIG_USB_GL860
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gl860/gspca_gl860.ko
  AUTOLOAD:=$(call AutoProbe,gspca_gl860)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-gl860/description
 The GL860 USB Camera Driver (gl860) kernel module
endef

$(eval $(call KernelPackage,video-gspca-gl860))


define KernelPackage/video-gspca-jeilinj
  TITLE:=jeilinj webcam support
  KCONFIG:=CONFIG_USB_GSPCA_JEILINJ
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_jeilinj.ko
  AUTOLOAD:=$(call AutoProbe,gspca_jeilinj)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-jeilinj/description
 The JEILINJ USB Camera Driver (jeilinj) kernel module
endef

$(eval $(call KernelPackage,video-gspca-jeilinj))


define KernelPackage/video-gspca-konica
  TITLE:=konica webcam support
  KCONFIG:=CONFIG_USB_GSPCA_KONICA
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_konica.ko
  AUTOLOAD:=$(call AutoProbe,gspca_konica)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-konica/description
 The Konica USB Camera Driver (konica) kernel module
endef

$(eval $(call KernelPackage,video-gspca-konica))

#
# Video Processing
#

define KernelPackage/video-mem2mem
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Memory 2 Memory device support
  HIDDEN:=1
  DEPENDS:=+kmod-video-videobuf2
  KCONFIG:= \
    CONFIG_V4L_MEM2MEM_DRIVERS=y \
    CONFIG_V4L2_MEM2MEM_DEV
  FILES:= $(LINUX_DIR)/drivers/media/$(V4L2_DIR)/v4l2-mem2mem.ko
  AUTOLOAD:=$(call AutoLoad,66,v4l2-mem2mem)
  $(call AddDepends/video)
endef

define KernelPackage/video-mem2mem/description
  Memory 2 memory device support
endef

$(eval $(call KernelPackage,video-mem2mem))

define KernelPackage/video-dma-contig
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Video DMA support
  HIDDEN:=1
  DEPENDS:=+kmod-video-videobuf2
  KCONFIG:=CONFIG_VIDEOBUF2_DMA_CONTIG
  FILES:=$(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-dma-contig.ko
  AUTOLOAD:=$(call AutoLoad,66,videobuf2-dma-contig)
  $(call AddDepends/video)
endef

define KernelPackage/video-dma-contig/description
  Video DMA support Contig
endef


$(eval $(call KernelPackage,video-dma-contig))

define KernelPackage/video-dma-sg
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Video DMA support
  HIDDEN:=1
  DEPENDS:=+kmod-video-videobuf2
  KCONFIG:=CONFIG_VIDEOBUF2_DMA_SG
  FILES:=$(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-dma-sg.ko
  AUTOLOAD:=$(call AutoLoad,66,videobuf2-dma-sg)
  $(call AddDepends/video)
endef

define KernelPackage/video-dma-sg/description
  Video DMA support SG
endef

$(eval $(call KernelPackage,video-dma-sg))

define KernelPackage/video-coda
  TITLE:=i.MX VPU support
  DEPENDS:=@(TARGET_imx&&TARGET_imx_cortexa9) +kmod-video-mem2mem +kmod-video-dma-contig
  KCONFIG:= \
	CONFIG_VIDEO_CODA \
	CONFIG_VIDEO_IMX_VDOA
  FILES:= \
	$(LINUX_DIR)/drivers/media/$(V4L2_MEM2MEM_DIR)/chips-media/coda-vpu.ko@lt6.12 \
	$(LINUX_DIR)/drivers/media/$(V4L2_MEM2MEM_DIR)/chips-media/imx-vdoa.ko@lt6.12 \
	$(LINUX_DIR)/drivers/media/$(V4L2_MEM2MEM_DIR)/chips-media/coda/coda-vpu.ko@ge6.12 \
	$(LINUX_DIR)/drivers/media/$(V4L2_MEM2MEM_DIR)/chips-media/coda/imx-vdoa.ko@ge6.12 \
	$(LINUX_DIR)/drivers/media/$(V4L2_DIR)/v4l2-jpeg.ko
  AUTOLOAD:=$(call AutoProbe,coda-vpu imx-vdoa v4l2-jpeg)
  $(call AddDepends/video)
endef

define KernelPackage/video-coda/description
 The i.MX Video Processing Unit (VPU) kernel module
endef

$(eval $(call KernelPackage,video-coda))

define KernelPackage/video-pxp
  TITLE:=i.MX PXP support
  DEPENDS:=@TARGET_imx +kmod-video-mem2mem +kmod-video-dma-contig
  KCONFIG:= CONFIG_VIDEO_IMX_PXP
  FILES:= $(LINUX_DIR)/drivers/media/platform/nxp/imx-pxp.ko
  AUTOLOAD:=$(call AutoProbe,imx-pxp)
  $(call AddDepends/video)
endef

define KernelPackage/video-pxp/description
 The i.MX Pixel Pipeline (PXP) kernel module
 This enables hardware accelerated support for image
 Colour Conversion, Scaling and Rotation
endef

$(eval $(call KernelPackage,video-pxp))

define KernelPackage/video-tw686x
  TITLE:=TW686x support
  DEPENDS:=@PCIE_SUPPORT +kmod-video-dma-contig +kmod-video-dma-sg +kmod-sound-core
  KCONFIG:= CONFIG_VIDEO_TW686X
  FILES:= $(LINUX_DIR)/drivers/media/pci/tw686x/tw686x.ko
  AUTOLOAD:=$(call AutoProbe,tw686x)
  MODPARAMS.tw686x:=dma_mode=contig
  $(call AddDepends/framegrabber)
endef

define KernelPackage/video-tw686x/description
 The Intersil/Techwell TW686x kernel module
endef

$(eval $(call KernelPackage,video-tw686x))
