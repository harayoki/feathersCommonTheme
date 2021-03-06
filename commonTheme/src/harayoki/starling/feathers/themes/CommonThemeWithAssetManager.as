﻿package harayoki.starling.feathers.themes
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.errors.IllegalOperationError;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.engine.CFFHinting;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.RenderingMode;
	import flash.utils.getQualifiedClassName;
	
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Callout;
	import feathers.controls.Check;
	import feathers.controls.GroupedList;
	import feathers.controls.Header;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.NumericStepper;
	import feathers.controls.PageIndicator;
	import feathers.controls.Panel;
	import feathers.controls.PanelScreen;
	import feathers.controls.PickerList;
	import feathers.controls.ProgressBar;
	import feathers.controls.Radio;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.ScrollScreen;
	import feathers.controls.ScrollText;
	import feathers.controls.Scroller;
	import feathers.controls.SimpleScrollBar;
	import feathers.controls.Slider;
	import feathers.controls.TabBar;
	import feathers.controls.TextInput;
	import feathers.controls.ToggleSwitch;
	import feathers.controls.popups.CalloutPopUpContentManager;
	import feathers.controls.popups.VerticalCenteredPopUpContentManager;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.core.DisplayListWatcher;
	import feathers.core.FeathersControl;
	import feathers.core.PopUpManager;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	import feathers.skins.StandardIcons;
	import feathers.system.DeviceCapabilities;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import harayoki.starling.feathers.themes.config.CommonThemeConfig;
	import harayoki.starling.feathers.themes.util.FontSwfLoader;
	import harayoki.starling.feathers.themes.util.FontUtil;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;

	[Event(name="complete",type="starling.events.Event")]

	public class CommonThemeWithAssetManager extends DisplayListWatcher
	{
		protected static const ORIGINAL_DPI_IPHONE_RETINA:int = 326;
		protected static const ORIGINAL_DPI_IPAD_RETINA:int = 264;
		
		public static const COMPONENT_NAME_PICKER_LIST_ITEM_RENDERER:String = "common-theme-mobile-picker-list-item-renderer";
		public static const COMPONENT_NAME_ALERT_BUTTON_GROUP_BUTTON:String = "common-theme-mobile-alert-button-group-button";
		

		protected static function textRendererFactory():TextBlockTextRenderer
		{
			return new TextBlockTextRenderer();
		}

		protected static function textEditorFactory():StageTextTextEditor
		{
			return new StageTextTextEditor();
		}

		protected static function stepperTextEditorFactory():TextFieldTextEditor
		{
			return new TextFieldTextEditor();
		}

		//元はstatic だがconfigの値を参照したいので変更
		protected function popUpOverlayFactory():starling.display.DisplayObject
		{
			const quad:Quad = new Quad(100, 100, this._config.modalOverlayColor.colorData);
			quad.alpha = this._config.modalOverlayAlpha;
			return quad;
		}

		public function CommonThemeWithAssetManager(themeId:String,assets:Object = null, assetManager:AssetManager = null, container:DisplayObjectContainer = null, scaleToDPI:Boolean = true)
		{
			if(!container)
			{
				container = Starling.current.stage;
			}
			super(container);
			this._scaleToDPI = scaleToDPI;
			this._config = new CommonThemeConfig(themeId);
			this.processSource(assets, assetManager);
		}

		protected var _config:CommonThemeConfig;
		
		public function get config():CommonThemeConfig
		{
			return this._config;
		}
		
		protected var _originalDPI:int;

		public function get originalDPI():int
		{
			return this._originalDPI;
		}

		protected var _scaleToDPI:Boolean;

		public function get scaleToDPI():Boolean
		{
			return this._scaleToDPI;
		}
		
		protected var assetManager:AssetManager;

		protected var scale:Number = 1;

		protected var regularFontDescription:FontDescription;
		protected var boldFontDescription:FontDescription;

		protected var scrollTextTextFormat:TextFormat;
		protected var lightUICenteredTextFormat:TextFormat;

		protected var headerElementFormat:ElementFormat;

		protected var darkUIElementFormat:ElementFormat;
		protected var lightUIElementFormat:ElementFormat;
		protected var selectedUIElementFormat:ElementFormat;
		protected var lightUIDisabledElementFormat:ElementFormat;
		protected var darkUIDisabledElementFormat:ElementFormat;

		protected var largeUIDarkElementFormat:ElementFormat;
		protected var largeUILightElementFormat:ElementFormat;
		protected var largeUISelectedElementFormat:ElementFormat;
		protected var largeUIDisabledElementFormat:ElementFormat;

		protected var largeDarkElementFormat:ElementFormat;
		protected var largeLightElementFormat:ElementFormat;
		protected var largeDisabledElementFormat:ElementFormat;

		protected var darkElementFormat:ElementFormat;
		protected var lightElementFormat:ElementFormat;
		protected var disabledElementFormat:ElementFormat;

		protected var smallLightElementFormat:ElementFormat;
		protected var smallDisabledElementFormat:ElementFormat;

		protected var atlas:TextureAtlas;
		protected var atlasTexture:Texture;
		protected var headerBackgroundSkinTexture:Texture;
		protected var backgroundSkinTextures:Scale9Textures;
		protected var backgroundInsetSkinTextures:Scale9Textures;
		protected var backgroundDisabledSkinTextures:Scale9Textures;
		protected var backgroundFocusedSkinTextures:Scale9Textures;
		protected var buttonUpSkinTextures:Scale9Textures;
		protected var buttonDownSkinTextures:Scale9Textures;
		protected var buttonDisabledSkinTextures:Scale9Textures;
		protected var buttonSelectedUpSkinTextures:Scale9Textures;
		protected var buttonSelectedDisabledSkinTextures:Scale9Textures;
		protected var buttonCallToActionUpSkinTextures:Scale9Textures;
		protected var buttonCallToActionDownSkinTextures:Scale9Textures;
		protected var buttonDangerUpSkinTextures:Scale9Textures;
		protected var buttonDangerDownSkinTextures:Scale9Textures;
		protected var buttonBackUpSkinTextures:Scale3Textures;
		protected var buttonBackDownSkinTextures:Scale3Textures;
		protected var buttonBackDisabledSkinTextures:Scale3Textures;
		protected var buttonForwardUpSkinTextures:Scale3Textures;
		protected var buttonForwardDownSkinTextures:Scale3Textures;
		protected var buttonForwardDisabledSkinTextures:Scale3Textures;
		protected var pickerListButtonIconTexture:Texture;
		protected var tabDownSkinTextures:Scale9Textures;
		protected var tabSelectedSkinTextures:Scale9Textures;
		protected var tabSelectedDisabledSkinTextures:Scale9Textures;
		protected var pickerListItemSelectedIconTexture:Texture;
		protected var radioUpIconTexture:Texture;
		protected var radioDownIconTexture:Texture;
		protected var radioDisabledIconTexture:Texture;
		protected var radioSelectedUpIconTexture:Texture;
		protected var radioSelectedDownIconTexture:Texture;
		protected var radioSelectedDisabledIconTexture:Texture;
		protected var checkUpIconTexture:Texture;
		protected var checkDownIconTexture:Texture;
		protected var checkDisabledIconTexture:Texture;
		protected var checkSelectedUpIconTexture:Texture;
		protected var checkSelectedDownIconTexture:Texture;
		protected var checkSelectedDisabledIconTexture:Texture;
		protected var pageIndicatorNormalSkinTexture:Texture;
		protected var pageIndicatorSelectedSkinTexture:Texture;
		protected var itemRendererUpSkinTextures:Scale9Textures;
		protected var itemRendererSelectedSkinTextures:Scale9Textures;
		protected var insetItemRendererFirstUpSkinTextures:Scale9Textures;
		protected var insetItemRendererFirstSelectedSkinTextures:Scale9Textures;
		protected var insetItemRendererLastUpSkinTextures:Scale9Textures;
		protected var insetItemRendererLastSelectedSkinTextures:Scale9Textures;
		protected var insetItemRendererSingleUpSkinTextures:Scale9Textures;
		protected var insetItemRendererSingleSelectedSkinTextures:Scale9Textures;
		protected var backgroundPopUpSkinTextures:Scale9Textures;
		protected var calloutTopArrowSkinTexture:Texture;
		protected var calloutRightArrowSkinTexture:Texture;
		protected var calloutBottomArrowSkinTexture:Texture;
		protected var calloutLeftArrowSkinTexture:Texture;
		protected var verticalScrollBarThumbSkinTextures:Scale3Textures;
		protected var horizontalScrollBarThumbSkinTextures:Scale3Textures;
		protected var searchIconTexture:Texture;

		override public function dispose():void
		{
			if(this.root)
			{
				this.root.removeEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
			}
			if(this.atlas)
			{
				this.atlas.dispose();
				this.atlas = null;
				//no need to dispose the atlas texture because the atlas will do that
				this.atlasTexture = null;
			}
			if(this.assetManager)
			{
				
				this.assetManager.removeTextureAtlas(this._config.atlasName);
			}
			super.dispose();
		}

		protected function initializeRoot():void
		{
			if(this.root != this.root.stage)
			{
				return;
			}

			this.root.stage.color = this._config.backgroundColor.colorData;
			Starling.current.nativeStage.color = this._config.backgroundColor.colorData;
		}
		
		protected function assetManager_onComplete():void
		{
			this.initialize();
			this.dispatchEventWith(Event.COMPLETE);
		}

		protected function processSource(assets:Object, assetManager:AssetManager):void
		{
			if(assets)
			{
				function isDirectory():Boolean
				{
					return getQualifiedClassName(assets) == "flash.filesystem::File" && assets["isDirectory"];
				}
				
				this.assetManager = assetManager;
				if(!this.assetManager)
				{
					this.assetManager = new AssetManager(Starling.contentScaleFactor);
				}
				if(assets is String)
				{
					var assetsDirectoryName:String = assets as String;
					if(assetsDirectoryName.lastIndexOf("/") != assetsDirectoryName.length - 1)
					{
						assets = assetsDirectoryName + "/";
					}
					this.assetManager.enqueue(assets + this._config.themeId + ".xml");
					this.assetManager.enqueue(assets + this._config.themeId + ".png");
					this.assetManager.enqueue(assets + this._config.themeId + "_config.json");
				}
				else if(isDirectory())
				{
					this.assetManager.enqueue(assets["resolvePath"](this._config.themeId + ".xml"));
					this.assetManager.enqueue(assets["resolvePath"](this._config.themeId + ".png"));
					this.assetManager.enqueue(assets["resolvePath"](this._config.themeId + "_config.json"));
				}
				else
				{
					//this.assetManager.enqueue(assets);
					throw new Error("assets must be 'filepath as String' or 'directory as File Object'. Theme not loaded.");
				}
				var self:CommonThemeWithAssetManager = this;
				
				function onProgress (progress:Number):void
				{
					if(progress<1) return;
					
					self.initializeConfig();
					if(self._config.fontFile)
					{
						trace("load fontfile",self._config.fontFile);
						var loader:FontSwfLoader = new FontSwfLoader();
						if(assets is String)
						{
							loader.load(assets + self._config.fontFile,onFontSwfLoad);
						}
						else
						{
							loader.load(assets["resolvePath"](self._config.fontFile)["nativePath"] as String,onFontSwfLoad);//TODO 未検証
						}
					}						
					else
					{
						assetManager_onComplete();
					}
				}
				
				function onFontSwfLoad():void
				{
					assetManager_onComplete();
				}
				
				this.assetManager.loadQueue(onProgress);
				
			}
			else
			{
				throw new Error("Asset path not found. Theme not loaded.");
			}
		}

		protected function initialize():void
		{
				
			if(!this.atlas)
			{
				if(this.assetManager)
				{
					//trace("this._themeConfig.atlasname",this._config.atlasName);
					this.atlas = this.assetManager.getTextureAtlas(this._config.atlasName);
				}
				else
				{
					throw new IllegalOperationError("Atlas not loaded.");
				}
			}

			this.initializeScale();
			this.initializeFonts();
			this.initializeTextures();
			this.initializeGlobals();

			if(this.root.stage)
			{
				this.initializeRoot();
			}
			else
			{
				this.root.addEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
			}

			this.setInitializers();
		}
		
		protected function initializeConfig():void
		{
			this._config.applyJsonData(this.assetManager.getObject(this._config.themeId + "_config"));
		}

		protected function initializeGlobals():void
		{
			FeathersControl.defaultTextRendererFactory = textRendererFactory;
			FeathersControl.defaultTextEditorFactory = textEditorFactory;

			PopUpManager.overlayFactory = popUpOverlayFactory;
			Callout.stagePaddingTop = this._config.calloutStagePadding.top * this.scale;
			Callout.stagePaddingRight = this._config.calloutStagePadding.right * this.scale;
			Callout.stagePaddingBottom = this._config.calloutStagePadding.bottom * this.scale;
			Callout.stagePaddingLeft = this._config.calloutStagePadding.left * this.scale;
		}

		protected function initializeScale():void
		{
			var scaledDPI:int = DeviceCapabilities.dpi / Starling.contentScaleFactor;
			this._originalDPI = scaledDPI;
			if(this._scaleToDPI)
			{
				if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
				{
					this._originalDPI = ORIGINAL_DPI_IPAD_RETINA;
				}
				else
				{
					this._originalDPI = ORIGINAL_DPI_IPHONE_RETINA;
				}
			}
			this.scale = scaledDPI / this._originalDPI;
		}
		
		protected function initializeFonts():void
		{
			
			trace("EmbedFonts:",FontUtil.getAllEmbedFontInfos());
			trace("DeviceFonts:",FontUtil.getAllDeviceFontInfos());
			var fontLookup:String = FontLookup.EMBEDDED_CFF;
			var fontName:String = this._config.fontName;
			
			if(fontName)
			{
				trace("fontName : "+fontName);	
			}
			else
			{
				trace("font '"+fontName+"' not found, use _sans");	
				fontName = "_sans";
			}
			
			if(FontUtil.isDefaultFontFamily(fontName) || FontUtil.isDeveiceFont(fontName))
			{
				trace(fontName + " is device font");
				fontLookup = FontLookup.DEVICE;
			}
			
			var locale:String = this._config.fontLocale ? this._config.fontLocale : "en";
			
			//these are for components that don't use FTE
			this.scrollTextTextFormat = new TextFormat(fontName, this._config.fontSizeNormal * this.scale, this._config.lightTextColor);
			this.lightUICenteredTextFormat = new TextFormat(fontName, this._config.fontSizeNormal * this.scale, this._config.lightTextColor, true, null, null, null, null, TextFormatAlign.CENTER);

			this.regularFontDescription = new FontDescription(fontName, FontWeight.NORMAL, FontPosture.NORMAL, fontLookup, RenderingMode.CFF, CFFHinting.NONE);
			this.boldFontDescription = new FontDescription(fontName, FontWeight.BOLD, FontPosture.NORMAL, fontLookup, RenderingMode.CFF, CFFHinting.NONE);
			
			this.headerElementFormat = new ElementFormat(this.boldFontDescription, Math.round(this._config.fontSizeHeader * this.scale), this._config.lightTextColor.colorData);
			this.headerElementFormat.locale = locale;
			
			this.darkUIElementFormat = new ElementFormat(this.boldFontDescription, this._config.fontSizeNormal * this.scale, this._config.darkTextColor.colorData);
			this.darkUIElementFormat.locale = locale;			
			this.lightUIElementFormat = new ElementFormat(this.boldFontDescription, this._config.fontSizeNormal * this.scale, this._config.lightTextColor.colorData);
			this.lightUIElementFormat.locale = locale;
			this.selectedUIElementFormat = new ElementFormat(this.boldFontDescription, this._config.fontSizeNormal * this.scale, this._config.selectedTextColor.colorData);
			this.selectedUIElementFormat.locale = locale;
			this.lightUIDisabledElementFormat = new ElementFormat(this.boldFontDescription, this._config.fontSizeNormal * this.scale, this._config.disabledTextColor.colorData);
			this.lightUIDisabledElementFormat.locale = locale;
			this.darkUIDisabledElementFormat = new ElementFormat(this.boldFontDescription, this._config.fontSizeNormal * this.scale, this._config.darkDisabledTextColor.colorData);
			this.darkUIDisabledElementFormat.locale = locale;

			this.largeUIDarkElementFormat = new ElementFormat(this.boldFontDescription, this._config.fontSizeLarge * this.scale, this._config.darkTextColor.colorData);
			this.largeUIDarkElementFormat.locale = locale;
			this.largeUILightElementFormat = new ElementFormat(this.boldFontDescription, this._config.fontSizeLarge * this.scale, this._config.lightTextColor.colorData);
			this.largeUILightElementFormat.locale = locale;
			this.largeUISelectedElementFormat = new ElementFormat(this.boldFontDescription, this._config.fontSizeLarge * this.scale, this._config.selectedTextColor.colorData);
			this.largeUISelectedElementFormat.locale = locale;
			this.largeUIDisabledElementFormat = new ElementFormat(this.boldFontDescription, this._config.fontSizeLarge * this.scale, this._config.disabledTextColor.colorData);
			this.largeUIDisabledElementFormat.locale = locale;

			this.darkElementFormat = new ElementFormat(this.regularFontDescription, this._config.fontSizeNormal * this.scale, this._config.darkTextColor.colorData);
			this.darkElementFormat.locale = locale;
			this.lightElementFormat = new ElementFormat(this.regularFontDescription, this._config.fontSizeNormal * this.scale, this._config.lightTextColor.colorData);
			this.lightElementFormat.locale = locale;
			this.disabledElementFormat = new ElementFormat(this.regularFontDescription, this._config.fontSizeNormal * this.scale, this._config.disabledTextColor.colorData);
			this.disabledElementFormat.locale = locale;

			this.smallLightElementFormat = new ElementFormat(this.regularFontDescription, this._config.fontSizeSmall * this.scale, this._config.lightTextColor.colorData);
			this.smallLightElementFormat.locale = locale;
			this.smallDisabledElementFormat = new ElementFormat(this.regularFontDescription, this._config.fontSizeSmall * this.scale, this._config.disabledTextColor.colorData);
			this.smallDisabledElementFormat.locale = locale;

			this.largeDarkElementFormat = new ElementFormat(this.regularFontDescription, this._config.fontSizeLarge * this.scale, this._config.darkTextColor.colorData);
			this.largeDarkElementFormat.locale = locale;
			this.largeLightElementFormat = new ElementFormat(this.regularFontDescription, this._config.fontSizeLarge * this.scale, this._config.lightTextColor.colorData);
			this.largeLightElementFormat.locale = locale;
			this.largeDisabledElementFormat = new ElementFormat(this.regularFontDescription, this._config.fontSizeLarge * this.scale, this._config.disabledTextColor.colorData);
			this.largeDisabledElementFormat.locale = locale;
		}

		protected function initializeTextures():void
		{
			const backgroundSkinTexture:Texture = this.atlas.getTexture("background-skin");
			const backgroundInsetSkinTexture:Texture = this.atlas.getTexture("background-inset-skin");
			const backgroundDownSkinTexture:Texture = this.atlas.getTexture("background-down-skin");
			const backgroundDisabledSkinTexture:Texture = this.atlas.getTexture("background-disabled-skin");
			const backgroundFocusedSkinTexture:Texture = this.atlas.getTexture("background-focused-skin");
			const backgroundPopUpSkinTexture:Texture = this.atlas.getTexture("background-popup-skin");

			this.backgroundSkinTextures = new Scale9Textures(backgroundSkinTexture, this._config.defaultScale9Grid);
			this.backgroundInsetSkinTextures = new Scale9Textures(backgroundInsetSkinTexture, this._config.defaultScale9Grid);
			this.backgroundDisabledSkinTextures = new Scale9Textures(backgroundDisabledSkinTexture, this._config.defaultScale9Grid);
			this.backgroundFocusedSkinTextures = new Scale9Textures(backgroundFocusedSkinTexture, this._config.defaultScale9Grid);
			this.backgroundPopUpSkinTextures = new Scale9Textures(backgroundPopUpSkinTexture, this._config.defaultScale9Grid);

			this.buttonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-up-skin"), this._config.buttonScale9Grid);
			this.buttonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-down-skin"), this._config.buttonScale9Grid);
			this.buttonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-disabled-skin"), this._config.buttonScale9Grid);
			this.buttonSelectedUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-up-skin"), this._config.buttonSelectedScale9Grid);
			this.buttonSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-disabled-skin"), this._config.buttonSelectedScale9Grid);
			this.buttonCallToActionUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-call-to-action-up-skin"), this._config.buttonScale9Grid);
			this.buttonCallToActionDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-call-to-action-down-skin"), this._config.buttonScale9Grid);
			this.buttonDangerUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-danger-up-skin"), this._config.buttonScale9Grid);
			this.buttonDangerDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-danger-down-skin"), this._config.buttonScale9Grid);
			this.buttonBackUpSkinTextures = new Scale3Textures(this.atlas.getTexture("button-back-up-skin"), this._config.backButtonScale3Region1, this._config.backButtonScale3Region2);
			this.buttonBackDownSkinTextures = new Scale3Textures(this.atlas.getTexture("button-back-down-skin"), this._config.backButtonScale3Region1, this._config.backButtonScale3Region2);
			this.buttonBackDisabledSkinTextures = new Scale3Textures(this.atlas.getTexture("button-back-disabled-skin"), this._config.backButtonScale3Region1, this._config.backButtonScale3Region2);
			this.buttonForwardUpSkinTextures = new Scale3Textures(this.atlas.getTexture("button-forward-up-skin"), this._config.forwardButtonScale3Region1, this._config.forwardButtonScale3Region3);
			this.buttonForwardDownSkinTextures = new Scale3Textures(this.atlas.getTexture("button-forward-down-skin"), this._config.forwardButtonScale3Region1, this._config.forwardButtonScale3Region3);
			this.buttonForwardDisabledSkinTextures = new Scale3Textures(this.atlas.getTexture("button-forward-disabled-skin"), this._config.forwardButtonScale3Region1, this._config.forwardButtonScale3Region3);

			this.tabDownSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-down-skin"), this._config.tabScale9Grid);
			this.tabSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-skin"), this._config.tabScale9Grid);
			this.tabSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-disabled-skin"), this._config.tabScale9Grid);

			this.pickerListButtonIconTexture = this.atlas.getTexture("picker-list-icon");
			this.pickerListItemSelectedIconTexture = this.atlas.getTexture("picker-list-item-selected-icon");

			this.radioUpIconTexture = backgroundSkinTexture;
			this.radioDownIconTexture = backgroundDownSkinTexture;
			this.radioDisabledIconTexture = backgroundDisabledSkinTexture;
			this.radioSelectedUpIconTexture = this.atlas.getTexture("radio-selected-up-icon");
			this.radioSelectedDownIconTexture = this.atlas.getTexture("radio-selected-down-icon");
			this.radioSelectedDisabledIconTexture = this.atlas.getTexture("radio-selected-disabled-icon");

			this.checkUpIconTexture = backgroundSkinTexture;
			this.checkDownIconTexture = backgroundDownSkinTexture;
			this.checkDisabledIconTexture = backgroundDisabledSkinTexture;
			this.checkSelectedUpIconTexture = this.atlas.getTexture("check-selected-up-icon");
			this.checkSelectedDownIconTexture = this.atlas.getTexture("check-selected-down-icon");
			this.checkSelectedDisabledIconTexture = this.atlas.getTexture("check-selected-disabled-icon");

			this.pageIndicatorSelectedSkinTexture = this.atlas.getTexture("page-indicator-selected-skin");
			this.pageIndicatorNormalSkinTexture = this.atlas.getTexture("page-indicator-normal-skin");

			this.searchIconTexture = this.atlas.getTexture("search-icon");

			this.itemRendererUpSkinTextures = new Scale9Textures(this.atlas.getTexture("list-item-up-skin"), this._config.itemRendererScale8Grid);
			this.itemRendererSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("list-item-selected-skin"), this._config.itemRendererScale8Grid);
			this.insetItemRendererFirstUpSkinTextures = new Scale9Textures(this.atlas.getTexture("list-inset-item-first-up-skin"), this._config.insetItemRendererFirstScale9Grid);
			this.insetItemRendererFirstSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("list-inset-item-first-selected-skin"), this._config.insetItemRendererFirstScale9Grid);
			this.insetItemRendererLastUpSkinTextures = new Scale9Textures(this.atlas.getTexture("list-inset-item-last-up-skin"), this._config.insetItemRendererLastScale9Grid);
			this.insetItemRendererLastSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("list-inset-item-last-selected-skin"), this._config.insetItemRendererLastScale9Grid);
			this.insetItemRendererSingleUpSkinTextures = new Scale9Textures(this.atlas.getTexture("list-inset-item-single-up-skin"), this._config.insetItemRendererSingleScale9Grid);
			this.insetItemRendererSingleSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("list-inset-item-single-selected-skin"), this._config.insetItemRendererSingleScale9Grid);

			this.headerBackgroundSkinTexture = this.atlas.getTexture("header-background-skin");

			this.calloutTopArrowSkinTexture = this.atlas.getTexture("callout-arrow-top-skin");
			this.calloutRightArrowSkinTexture = this.atlas.getTexture("callout-arrow-right-skin");
			this.calloutBottomArrowSkinTexture = this.atlas.getTexture("callout-arrow-bottom-skin");
			this.calloutLeftArrowSkinTexture = this.atlas.getTexture("callout-arrow-left-skin");

			this.horizontalScrollBarThumbSkinTextures = new Scale3Textures(this.atlas.getTexture("horizontal-scroll-bar-thumb-skin"), this._config.scrollBarThumbRegion1, this._config.scrollBarThumbRegion2, Scale3Textures.DIRECTION_HORIZONTAL);
			this.verticalScrollBarThumbSkinTextures = new Scale3Textures(this.atlas.getTexture("vertical-scroll-bar-thumb-skin"), this._config.scrollBarThumbRegion1, this._config.scrollBarThumbRegion2, Scale3Textures.DIRECTION_VERTICAL);

			StandardIcons.listDrillDownAccessoryTexture = this.atlas.getTexture("list-accessory-drill-down-icon");
		}

		protected function setInitializers():void
		{
			this.setInitializerForClassAndSubclasses(Screen, screenInitializer);
			this.setInitializerForClassAndSubclasses(PanelScreen, panelScreenInitializer);
			this.setInitializerForClassAndSubclasses(ScrollScreen, scrollScreenInitializer);
			this.setInitializerForClass(Label, labelInitializer);
			this.setInitializerForClass(Label, headingLabelInitializer, Label.ALTERNATE_NAME_HEADING);
			this.setInitializerForClass(Label, detailLabelInitializer, Label.ALTERNATE_NAME_DETAIL);
			this.setInitializerForClass(TextBlockTextRenderer, itemRendererAccessoryLabelInitializer, BaseDefaultItemRenderer.DEFAULT_CHILD_NAME_ACCESSORY_LABEL);
			this.setInitializerForClass(TextBlockTextRenderer, alertMessageInitializer, Alert.DEFAULT_CHILD_NAME_MESSAGE);
			this.setInitializerForClass(ScrollText, scrollTextInitializer);
			this.setInitializerForClass(Button, buttonInitializer);
			this.setInitializerForClass(Button, callToActionButtonInitializer, Button.ALTERNATE_NAME_CALL_TO_ACTION_BUTTON);
			this.setInitializerForClass(Button, quietButtonInitializer, Button.ALTERNATE_NAME_QUIET_BUTTON);
			this.setInitializerForClass(Button, dangerButtonInitializer, Button.ALTERNATE_NAME_DANGER_BUTTON);
			this.setInitializerForClass(Button, backButtonInitializer, Button.ALTERNATE_NAME_BACK_BUTTON);
			this.setInitializerForClass(Button, forwardButtonInitializer, Button.ALTERNATE_NAME_FORWARD_BUTTON);
			this.setInitializerForClass(Button, buttonGroupButtonInitializer, ButtonGroup.DEFAULT_CHILD_NAME_BUTTON);
			this.setInitializerForClass(Button, alertButtonGroupButtonInitializer, COMPONENT_NAME_ALERT_BUTTON_GROUP_BUTTON);
			this.setInitializerForClass(Button, simpleButtonInitializer, ToggleSwitch.DEFAULT_CHILD_NAME_THUMB);
			this.setInitializerForClass(Button, simpleButtonInitializer, Slider.DEFAULT_CHILD_NAME_THUMB);
			this.setInitializerForClass(Button, pickerListButtonInitializer, PickerList.DEFAULT_CHILD_NAME_BUTTON);
			this.setInitializerForClass(Button, tabInitializer, TabBar.DEFAULT_CHILD_NAME_TAB);
			this.setInitializerForClass(Button, nothingInitializer, Slider.DEFAULT_CHILD_NAME_MINIMUM_TRACK);
			this.setInitializerForClass(Button, nothingInitializer, Slider.DEFAULT_CHILD_NAME_MAXIMUM_TRACK);
			this.setInitializerForClass(Button, toggleSwitchTrackInitializer, ToggleSwitch.DEFAULT_CHILD_NAME_ON_TRACK);
			this.setInitializerForClass(Button, nothingInitializer, SimpleScrollBar.DEFAULT_CHILD_NAME_THUMB);
			this.setInitializerForClass(ButtonGroup, buttonGroupInitializer);
			this.setInitializerForClass(ButtonGroup, alertButtonGroupInitializer, Alert.DEFAULT_CHILD_NAME_BUTTON_GROUP);
			this.setInitializerForClass(DefaultListItemRenderer, itemRendererInitializer);
			this.setInitializerForClass(DefaultListItemRenderer, pickerListItemRendererInitializer, COMPONENT_NAME_PICKER_LIST_ITEM_RENDERER);
			this.setInitializerForClass(DefaultGroupedListItemRenderer, itemRendererInitializer);
			this.setInitializerForClass(DefaultGroupedListItemRenderer, insetMiddleItemRendererInitializer, GroupedList.ALTERNATE_CHILD_NAME_INSET_ITEM_RENDERER);
			this.setInitializerForClass(DefaultGroupedListItemRenderer, insetFirstItemRendererInitializer, GroupedList.ALTERNATE_CHILD_NAME_INSET_FIRST_ITEM_RENDERER);
			this.setInitializerForClass(DefaultGroupedListItemRenderer, insetLastItemRendererInitializer, GroupedList.ALTERNATE_CHILD_NAME_INSET_LAST_ITEM_RENDERER);
			this.setInitializerForClass(DefaultGroupedListItemRenderer, insetSingleItemRendererInitializer, GroupedList.ALTERNATE_CHILD_NAME_INSET_SINGLE_ITEM_RENDERER);
			this.setInitializerForClass(DefaultGroupedListHeaderOrFooterRenderer, headerRendererInitializer);
			this.setInitializerForClass(DefaultGroupedListHeaderOrFooterRenderer, footerRendererInitializer, GroupedList.DEFAULT_CHILD_NAME_FOOTER_RENDERER);
			this.setInitializerForClass(DefaultGroupedListHeaderOrFooterRenderer, insetHeaderRendererInitializer, GroupedList.ALTERNATE_CHILD_NAME_INSET_HEADER_RENDERER);
			this.setInitializerForClass(DefaultGroupedListHeaderOrFooterRenderer, insetFooterRendererInitializer, GroupedList.ALTERNATE_CHILD_NAME_INSET_FOOTER_RENDERER);
			this.setInitializerForClass(Radio, radioInitializer);
			this.setInitializerForClass(Check, checkInitializer);
			this.setInitializerForClass(Slider, sliderInitializer);
			this.setInitializerForClass(ToggleSwitch, toggleSwitchInitializer);
			this.setInitializerForClass(NumericStepper, numericStepperInitializer);
			this.setInitializerForClass(TextInput, textInputInitializer);
			this.setInitializerForClass(TextInput, searchTextInputInitializer, TextInput.ALTERNATE_NAME_SEARCH_TEXT_INPUT);
			this.setInitializerForClass(TextInput, numericStepperTextInputInitializer, NumericStepper.DEFAULT_CHILD_NAME_TEXT_INPUT);
			this.setInitializerForClass(PageIndicator, pageIndicatorInitializer);
			this.setInitializerForClass(ProgressBar, progressBarInitializer);
			this.setInitializerForClass(PickerList, pickerListInitializer);
			this.setInitializerForClass(Header, headerInitializer);
			this.setInitializerForClass(Header, headerWithoutBackgroundInitializer, Panel.DEFAULT_CHILD_NAME_HEADER);
			this.setInitializerForClass(Header, headerWithoutBackgroundInitializer, Alert.DEFAULT_CHILD_NAME_HEADER);
			this.setInitializerForClass(Callout, calloutInitializer);
			this.setInitializerForClass(SimpleScrollBar, horizontalScrollBarInitializer, Scroller.DEFAULT_CHILD_NAME_HORIZONTAL_SCROLL_BAR);
			this.setInitializerForClass(SimpleScrollBar, verticalScrollBarInitializer, Scroller.DEFAULT_CHILD_NAME_VERTICAL_SCROLL_BAR);
			this.setInitializerForClass(List, listInitializer);
			this.setInitializerForClass(GroupedList, groupedListInitializer);
			this.setInitializerForClass(GroupedList, insetGroupedListInitializer, GroupedList.ALTERNATE_NAME_INSET_GROUPED_LIST);
			this.setInitializerForClass(Panel, panelInitializer);
			this.setInitializerForClass(Alert, alertInitializer);
			this.setInitializerForClass(ScrollContainer, scrollContainerToolbarInitializer, ScrollContainer.ALTERNATE_NAME_TOOLBAR);
		}

		protected function pageIndicatorNormalSymbolFactory():starling.display.DisplayObject
		{
			const symbol:ImageLoader = new ImageLoader();
			symbol.source = this.pageIndicatorNormalSkinTexture;
			symbol.textureScale = this.scale;
			return symbol;
		}

		protected function pageIndicatorSelectedSymbolFactory():starling.display.DisplayObject
		{
			const symbol:ImageLoader = new ImageLoader();
			symbol.source = this.pageIndicatorSelectedSkinTexture;
			symbol.textureScale = this.scale;
			return symbol;
		}

		protected function imageLoaderFactory():ImageLoader
		{
			const image:ImageLoader = new ImageLoader();
			image.textureScale = this.scale;
			return image;
		}

		protected function nothingInitializer(target:starling.display.DisplayObject):void {}

		protected function screenInitializer(screen:Screen):void
		{
			screen.originalDPI = this._originalDPI;
		}

		protected function panelScreenInitializer(screen:PanelScreen):void
		{
			screen.originalDPI = this._originalDPI;
		}

		protected function scrollScreenInitializer(screen:ScrollScreen):void
		{
			screen.originalDPI = this._originalDPI;
		}

		protected function simpleButtonInitializer(button:Button):void
		{
			const skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: 60 * this.scale,
				height: 60 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.minWidth = this._config.simpleBtnMinSize.width + this.scale;
			button.minHeight = this._config.simpleBtnMinSize.height * this.scale;
			button.minTouchWidth = this._config.simpleBtnMinTouchSize.width * this.scale;
			button.minTouchHeight = this._config.simpleBtnMinTouchSize.height * this.scale;
		}

		protected function labelInitializer(label:Label):void
		{
			label.textRendererProperties.elementFormat = this.lightElementFormat;
			label.textRendererProperties.disabledElementFormat = this.disabledElementFormat;
		}

		protected function headingLabelInitializer(label:Label):void
		{
			label.textRendererProperties.elementFormat = this.largeLightElementFormat;
			label.textRendererProperties.disabledElementFormat = this.largeDisabledElementFormat;
		}

		protected function detailLabelInitializer(label:Label):void
		{
			label.textRendererProperties.elementFormat = this.smallLightElementFormat;
			label.textRendererProperties.disabledElementFormat = this.smallDisabledElementFormat;
		}

		protected function itemRendererAccessoryLabelInitializer(renderer:TextBlockTextRenderer):void
		{
			renderer.elementFormat = this.lightElementFormat;
		}

		protected function alertMessageInitializer(renderer:TextBlockTextRenderer):void
		{
			renderer.wordWrap = true;
			renderer.elementFormat = this.lightElementFormat;
		}

		protected function scrollTextInitializer(text:ScrollText):void
		{
			text.textFormat = this.scrollTextTextFormat;
			text.paddingTop = this._config.scrollTextPadding.top * this.scale;
			text.paddingRight = this._config.scrollTextPadding.right * this.scale;
			text.paddingBottom = this._config.scrollTextPadding.bottom * this.scale;
			text.paddingLeft = this._config.scrollTextPadding.left * this.scale;
		}

		protected function baseButtonInitializer(button:Button):void
		{
			button.defaultLabelProperties.elementFormat = this.darkUIElementFormat;
			button.disabledLabelProperties.elementFormat = this.darkUIDisabledElementFormat;
			button.selectedDisabledLabelProperties.elementFormat = this.darkUIDisabledElementFormat;

			button.paddingTop = this._config.btnPadding.top * this.scale;
			button.paddingBottom = this._config.btnPadding.bottom * this.scale;
			button.paddingLeft = this._config.btnPadding.left * this.scale;
			button.paddingRight = this._config.btnPadding.right * this.scale;
			button.gap = this._config.btnGap * this.scale;
			button.minWidth = this._config.btnMinSize.width * this.scale;
			button.minHeight = this._config.btnMinSize.height * this.scale;
			button.minTouchWidth = this._config.btnMinTouchSize.width * this.scale;
			button.minTouchHeight = this._config.btnMinTouchSize.height * this.scale;
		}

		protected function buttonInitializer(button:Button):void
		{
			const skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.defaultSelectedValue = this.buttonSelectedUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			skinSelector.displayObjectProperties =
			{
				width: 60 * this.scale,
				height: 60 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.baseButtonInitializer(button);
		}

		protected function callToActionButtonInitializer(button:Button):void
		{
			const skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonCallToActionUpSkinTextures;
			skinSelector.setValueForState(this.buttonCallToActionDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: 60 * this.scale,
				height: 60 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.baseButtonInitializer(button);
		}

		protected function quietButtonInitializer(button:Button):void
		{
			const skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = null;
			skinSelector.defaultSelectedValue = this.buttonSelectedUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.displayObjectProperties =
			{
				width: 60 * this.scale,
				height: 60 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultLabelProperties.elementFormat = this.lightUIElementFormat;
			button.downLabelProperties.elementFormat = this.darkUIElementFormat;
			button.disabledLabelProperties.elementFormat = this.lightUIDisabledElementFormat;
			button.defaultSelectedLabelProperties.elementFormat = this.darkUIElementFormat;
			button.selectedDisabledLabelProperties.elementFormat = this.darkUIDisabledElementFormat;

			button.paddingTop = this._config.quietBtnPadding.top * this.scale;
			button.paddingRight = this._config.quietBtnPadding.right * this.scale;
			button.paddingBottom = this._config.quietBtnPadding.bottom * this.scale;
			button.paddingLeft = this._config.quietBtnPadding.left * this.scale;
			button.gap = this._config.quietBtnGap * this.scale;
			button.minWidth = this._config.quietBtnMinSize.width * this.scale;
			button.minHeight = this._config.quietBtnMinSize.height * this.scale;
			button.minTouchWidth = this._config.quietBtnMinTouchSize.width * this.scale;
			button.minTouchHeight = this._config.quietBtnMinTouchSize.height * this.scale;
		}

		protected function dangerButtonInitializer(button:Button):void
		{
			const skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonDangerUpSkinTextures;
			skinSelector.setValueForState(this.buttonDangerDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: 60 * this.scale,
				height: 60 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.baseButtonInitializer(button);
		}

		protected function backButtonInitializer(button:Button):void
		{
			const skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonBackUpSkinTextures;
			skinSelector.setValueForState(this.buttonBackDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonBackDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: 60 * this.scale,
				height: 60 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.baseButtonInitializer(button);
			button.paddingTop = this._config.backBtnPadding.top * this.scale;
			button.paddingBottom = this._config.backBtnPadding.bottom * this.scale;
			button.paddingLeft = this._config.backBtnPadding.left * this.scale;
			button.paddingRight = this._config.backBtnPadding.right * this.scale;
		}

		protected function forwardButtonInitializer(button:Button):void
		{
			const skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonForwardUpSkinTextures;
			skinSelector.setValueForState(this.buttonForwardDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonForwardDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: 60 * this.scale,
				height: 60 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.baseButtonInitializer(button);
			button.paddingTop = this._config.forwardBtnPadding.top * this.scale;
			button.paddingBottom = this._config.forwardBtnPadding.bottom * this.scale;
			button.paddingLeft = this._config.forwardBtnPadding.left * this.scale;
			button.paddingRight = this._config.forwardBtnPadding.right * this.scale;
		}

		protected function buttonGroupButtonInitializer(button:Button):void
		{
			const skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.defaultSelectedValue = this.buttonSelectedUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			skinSelector.displayObjectProperties =
			{
				width: 76 * this.scale,
				height: 76 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultLabelProperties.elementFormat = this.largeUIDarkElementFormat;
			button.disabledLabelProperties.elementFormat = this.largeUIDisabledElementFormat;
			button.selectedDisabledLabelProperties.elementFormat = this.largeUIDisabledElementFormat;

			button.paddingTop = this._config.btnGroupBtnPadding.top * this.scale;
			button.paddingRight = this._config.btnGroupBtnPadding.right * this.scale;
			button.paddingBottom = this._config.btnGroupBtnPadding.bottom * this.scale;
			button.paddingLeft = this._config.btnGroupBtnPadding.left * this.scale;
			button.gap = this._config.btnGroupBtnGap * this.scale;
			button.minWidth =  this._config.btnGroupBtnMinSize.width * this.scale;
			button.minHeight = this._config.btnGroupBtnMinSize.height * this.scale;
			button.minTouchWidth = this._config.btnGroupBtnMinTouchSize.width * this.scale;
			button.minTouchHeight = this._config.btnGroupBtnMinTouchSize.height * this.scale;
		}

		protected function alertButtonGroupButtonInitializer(button:Button):void
		{
			this.buttonInitializer(button);
			button.minWidth = this._config.alertBtnMinSize.width * this.scale;
			button.minHeight = this._config.alertBtnMinSize.height * this.scale;
		}

		protected function pickerListButtonInitializer(button:Button):void
		{
			this.buttonInitializer(button);

			const defaultIcon:ImageLoader = new ImageLoader();
			defaultIcon.source = this.pickerListButtonIconTexture;
			defaultIcon.textureScale = this.scale;
			defaultIcon.snapToPixels = true;
			button.defaultIcon = defaultIcon;

			button.gap = Number.POSITIVE_INFINITY;
			button.iconPosition = Button.ICON_POSITION_RIGHT;
		}

		protected function toggleSwitchTrackInitializer(track:Button):void
		{
			const skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.backgroundSkinTextures;
			skinSelector.setValueForState(this.backgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: 140 * this.scale,
				height: 60 * this.scale,
				textureScale: this.scale
			};
			track.stateToSkinFunction = skinSelector.updateValue;
		}

		protected function tabInitializer(tab:Button):void
		{
			const defaultSkin:Quad = new Quad(88 * this.scale, 88 * this.scale, this._config.tabBackgroundColor.colorData);
			tab.defaultSkin = defaultSkin;

			const downSkin:Scale9Image = new Scale9Image(this.tabDownSkinTextures, this.scale);
			tab.downSkin = downSkin;

			const defaultSelectedSkin:Scale9Image = new Scale9Image(this.tabSelectedSkinTextures, this.scale);
			tab.defaultSelectedSkin = defaultSelectedSkin;

			const disabledSkin:Quad = new Quad(88 * this.scale, 88 * this.scale, this._config.tabDisabledBackgroundColor.colorData);
			tab.disabledSkin = disabledSkin;

			const selectedDisabledSkin:Scale9Image = new Scale9Image(this.tabSelectedDisabledSkinTextures, this.scale);
			tab.selectedDisabledSkin = selectedDisabledSkin;

			tab.defaultLabelProperties.elementFormat = this.lightUIElementFormat;
			tab.defaultSelectedLabelProperties.elementFormat = this.darkUIElementFormat;
			tab.disabledLabelProperties.elementFormat = this.darkUIDisabledElementFormat;
			tab.selectedDisabledLabelProperties.elementFormat = this.darkUIDisabledElementFormat;

			tab.paddingTop = this._config.tabPadding.top * this.scale;
			tab.paddingRight = this._config.tabPadding.right * this.scale;
			tab.paddingBottom = this._config.tabPadding.bottom * this.scale;
			tab.paddingLeft = this._config.tabPadding.left * this.scale;
			tab.gap = this._config.tabGap * this.scale;
			tab.minWidth = this._config.tabMinSize.width * this.scale;
			tab.minHeight = this._config.tabMinSize.height * this.scale;
			tab.minTouchWidth = this._config.tabMinTouchSize.width * this.scale;
			tab.minTouchHeight = this._config.tabMinTouchSize.height * this.scale;
		}

		protected function buttonGroupInitializer(group:ButtonGroup):void
		{
			group.minWidth = this._config.btnGroupMinSize.width * this.scale;
			//btnGroupMinSize.heightは使われません
			
			group.gap = this._config.btnGroupGap * this.scale;
		}

		protected function alertButtonGroupInitializer(group:ButtonGroup):void
		{
			group.direction = ButtonGroup.DIRECTION_HORIZONTAL;
			group.horizontalAlign = ButtonGroup.HORIZONTAL_ALIGN_CENTER;
			group.verticalAlign = ButtonGroup.VERTICAL_ALIGN_JUSTIFY;
			group.distributeButtonSizes = false;
			group.gap = this._config.alertBtnGroupGap * this.scale;
			group.paddingTop = this._config.alertBtnGroupPadding.top * this.scale;
			group.paddingRight = this._config.alertBtnGroupPadding.right * this.scale;
			group.paddingBottom = this._config.alertBtnGroupPadding.bottom * this.scale;
			group.paddingLeft = this._config.alertBtnGroupPadding.left * this.scale;
			group.customButtonName = COMPONENT_NAME_ALERT_BUTTON_GROUP_BUTTON;
		}

		protected function itemRendererInitializer(renderer:BaseDefaultItemRenderer):void
		{
			const skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.itemRendererUpSkinTextures;
			skinSelector.defaultSelectedValue = this.itemRendererSelectedSkinTextures;
			skinSelector.setValueForState(this.itemRendererSelectedSkinTextures, Button.STATE_DOWN, false);
			skinSelector.displayObjectProperties =
			{
				width: 88 * this.scale,
				height: 88 * this.scale,
				textureScale: this.scale
			};
			renderer.stateToSkinFunction = skinSelector.updateValue;

			renderer.defaultLabelProperties.elementFormat = this.largeLightElementFormat;
			renderer.downLabelProperties.elementFormat = this.largeDarkElementFormat;
			renderer.defaultSelectedLabelProperties.elementFormat = this.largeDarkElementFormat;

			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			renderer.paddingTop = this._config.itemRendererPadding.top * this.scale;
			renderer.paddingRight = this._config.itemRendererPadding.right * this.scale;
			renderer.paddingBottom = this._config.itemRendererPadding.bottom * this.scale;
			renderer.paddingLeft = this._config.itemRendererPadding.left * this.scale;
			renderer.gap = this._config.itemRendererGap * this.scale;
			renderer.iconPosition = Button.ICON_POSITION_LEFT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
			renderer.minWidth = this._config.itemRendererMinSize.width * this.scale;
			renderer.minHeight = this._config.itemRendererMinSize.height * this.scale;
			renderer.minTouchWidth = this._config.itemRendererMinTouchSize.width * this.scale;
			renderer.minTouchHeight = this._config.itemRendererMinTouchSize.height * this.scale;

			renderer.accessoryLoaderFactory = this.imageLoaderFactory;
			renderer.iconLoaderFactory = this.imageLoaderFactory;
		}

		protected function pickerListItemRendererInitializer(renderer:BaseDefaultItemRenderer):void
		{
			const skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.itemRendererUpSkinTextures;
			skinSelector.setValueForState(this.itemRendererSelectedSkinTextures, Button.STATE_DOWN, false);
			skinSelector.displayObjectProperties =
			{
				width: 88 * this.scale,
				height: 88 * this.scale,
				textureScale: this.scale
			};
			renderer.stateToSkinFunction = skinSelector.updateValue;

			const defaultSelectedIcon:Image = new Image(this.pickerListItemSelectedIconTexture);
			defaultSelectedIcon.scaleX = defaultSelectedIcon.scaleY = this.scale;
			renderer.defaultSelectedIcon = defaultSelectedIcon;

			const defaultIcon:Quad = new Quad(defaultSelectedIcon.width, defaultSelectedIcon.height, 0xff00ff);
			defaultIcon.alpha = 0;
			renderer.defaultIcon = defaultIcon;

			renderer.defaultLabelProperties.elementFormat = this.largeLightElementFormat;
			renderer.downLabelProperties.elementFormat = this.largeDarkElementFormat;

			renderer.itemHasIcon = false;
			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			renderer.paddingTop = this._config.itemRendererPadding.top * this.scale;
			renderer.paddingRight = this._config.itemRendererPadding.right * this.scale;
			renderer.paddingBottom = this._config.itemRendererPadding.bottom * this.scale;
			renderer.paddingLeft = this._config.itemRendererPadding.left * this.scale;
			renderer.gap = Number.POSITIVE_INFINITY;
			renderer.iconPosition = Button.ICON_POSITION_RIGHT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
			renderer.minWidth = this._config.pickerListItemRendererMinSize.width * this.scale;
			renderer.minHeight = this._config.pickerListItemRendererMinSize.height * this.scale;
			renderer.minTouchWidth = this._config.pickerListItemRendererMinSize.width * this.scale;
			renderer.minTouchHeight = this._config.pickerListItemRendererMinSize.height * this.scale;
		}

		protected function insetItemRendererInitializer(renderer:DefaultGroupedListItemRenderer, defaultSkinTextures:Scale9Textures, selectedAndDownSkinTextures:Scale9Textures):void
		{
			const skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = defaultSkinTextures;
			skinSelector.defaultSelectedValue = selectedAndDownSkinTextures;
			skinSelector.setValueForState(selectedAndDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.displayObjectProperties =
			{
				width: 88 * this.scale,
				height: 88 * this.scale,
				textureScale: this.scale
			};
			renderer.stateToSkinFunction = skinSelector.updateValue;

			renderer.defaultLabelProperties.elementFormat = this.largeLightElementFormat;
			renderer.downLabelProperties.elementFormat = this.largeDarkElementFormat;
			renderer.defaultSelectedLabelProperties.elementFormat = this.largeDarkElementFormat;

			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			renderer.paddingTop = this._config.insetItemRendererPadding.top * this.scale;
			renderer.paddingRight = this._config.insetItemRendererPadding.right * this.scale;
			renderer.paddingBottom = this._config.insetItemRendererPadding.bottom * this.scale;
			renderer.paddingLeft = this._config.insetItemRendererPadding.left * this.scale;
			renderer.gap = this._config.insetItemRendererGap * this.scale;
			renderer.iconPosition = Button.ICON_POSITION_LEFT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
			renderer.minWidth = this._config.insetItemRendererMinSize.width * this.scale;
			renderer.minHeight = this._config.insetItemRendererMinSize.height * this.scale;
			renderer.minTouchWidth = this._config.insetItemRendererMinTouchSize.width * this.scale;
			renderer.minTouchHeight = this._config.insetItemRendererMinTouchSize.height * this.scale;

			renderer.accessoryLoaderFactory = this.imageLoaderFactory;
			renderer.iconLoaderFactory = this.imageLoaderFactory;
		}

		protected function insetMiddleItemRendererInitializer(renderer:DefaultGroupedListItemRenderer):void
		{
			this.insetItemRendererInitializer(renderer, this.itemRendererUpSkinTextures, this.itemRendererSelectedSkinTextures);
		}

		protected function insetFirstItemRendererInitializer(renderer:DefaultGroupedListItemRenderer):void
		{
			this.insetItemRendererInitializer(renderer, this.insetItemRendererFirstUpSkinTextures, this.insetItemRendererFirstSelectedSkinTextures);
		}

		protected function insetLastItemRendererInitializer(renderer:DefaultGroupedListItemRenderer):void
		{
			this.insetItemRendererInitializer(renderer, this.insetItemRendererLastUpSkinTextures, this.insetItemRendererLastSelectedSkinTextures);
		}

		protected function insetSingleItemRendererInitializer(renderer:DefaultGroupedListItemRenderer):void
		{
			this.insetItemRendererInitializer(renderer, this.insetItemRendererSingleUpSkinTextures, this.insetItemRendererSingleSelectedSkinTextures);
		}

		protected function headerRendererInitializer(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			const defaultSkin:Quad = new Quad(44 * this.scale, 44 * this.scale, this._config.groupedListHeaderBackgroundColor.colorData);
			renderer.backgroundSkin = defaultSkin;

			renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_LEFT;
			renderer.contentLabelProperties.elementFormat = this.lightUIElementFormat;
			renderer.paddingTop = this._config.headerRendererPadding.top * this.scale;
			renderer.paddingRight = this._config.headerRendererPadding.right * this.scale;
			renderer.paddingBottom = this._config.headerRendererPadding.bottom * this.scale;
			renderer.paddingLeft = this._config.headerRendererPadding.left * this.scale;
			renderer.minWidth = this._config.headerRendererMinSize.width * this.scale;
			renderer.minHeight = this._config.headerRendererMinSize.height * this.scale;
			renderer.minTouchWidth = this._config.headerRendererMinTouchSize.width * this.scale;
			renderer.minTouchHeight = this._config.headerRendererMinTouchSize.height * this.scale;

			renderer.contentLoaderFactory = this.imageLoaderFactory;
		}

		protected function footerRendererInitializer(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			const defaultSkin:Quad = new Quad(44 * this.scale, 44 * this.scale, this._config.groupedListFooterBackgroundColor.colorData);
			renderer.backgroundSkin = defaultSkin;

			renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_CENTER;
			renderer.contentLabelProperties.elementFormat = this.lightElementFormat;
			renderer.paddingTop = this._config.footerRendererPadding.top * this.scale;
			renderer.paddingRight = this._config.footerRendererPadding.right * this.scale;
			renderer.paddingBottom = this._config.footerRendererPadding.bottom * this.scale;
			renderer.paddingLeft = this._config.footerRendererPadding.left * this.scale;
			renderer.minWidth = this._config.footerRendererMinSize.width * this.scale;
			renderer.minHeight = this._config.footerRendererMinSize.height * this.scale;
			renderer.minTouchWidth = this._config.footerRendererMinTouchSize.width * this.scale;
			renderer.minTouchHeight = this._config.footerRendererMinTouchSize.height * this.scale;

			renderer.contentLoaderFactory = this.imageLoaderFactory;
		}

		protected function insetHeaderRendererInitializer(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			const defaultSkin:Quad = new Quad(66 * this.scale, 66 * this.scale, 0xff00ff);
			defaultSkin.alpha = 0;
			renderer.backgroundSkin = defaultSkin;

			renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_LEFT;
			renderer.contentLabelProperties.elementFormat = this.lightUIElementFormat;
			renderer.paddingTop = this._config.insetHeaderRendererPadding.top * this.scale;
			renderer.paddingRight = this._config.insetHeaderRendererPadding.right * this.scale;
			renderer.paddingBottom = this._config.insetHeaderRendererPadding.bottom * this.scale;
			renderer.paddingLeft = this._config.insetHeaderRendererPadding.left * this.scale;
			renderer.minWidth = this._config.insetHeaderRendererMinSize.width * this.scale;
			renderer.minHeight = this._config.insetHeaderRendererMinSize.height * this.scale;
			renderer.minTouchWidth = this._config.insetHeaderRendererMinTouchSize.width * this.scale;
			renderer.minTouchHeight = this._config.insetHeaderRendererMinTouchSize.height * this.scale;

			renderer.contentLoaderFactory = this.imageLoaderFactory;
		}

		protected function insetFooterRendererInitializer(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			const defaultSkin:Quad = new Quad(66 * this.scale, 66 * this.scale, 0xff00ff);
			defaultSkin.alpha = 0;
			renderer.backgroundSkin = defaultSkin;

			renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_CENTER;
			renderer.contentLabelProperties.elementFormat = this.lightElementFormat;
			renderer.paddingTop = this._config.insetFooterRendererPadding.top * this.scale;
			renderer.paddingRight = this._config.insetFooterRendererPadding.right * this.scale;
			renderer.paddingBottom = this._config.insetFooterRendererPadding.bottom * this.scale;
			renderer.paddingLeft = this._config.insetFooterRendererPadding.left * this.scale;
			renderer.minWidth = this._config.insetFooterRendererMinSize.width * this.scale;
			renderer.minHeight = this._config.insetFooterRendererMinSize.height * this.scale;
			renderer.minTouchWidth = this._config.insetFooterRendererMinTouchSize.width * this.scale;
			renderer.minTouchHeight = this._config.insetFooterRendererMinTouchSize.height * this.scale;

			renderer.contentLoaderFactory = this.imageLoaderFactory;
		}

		protected function radioInitializer(radio:Radio):void
		{
			const iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = this.radioUpIconTexture;
			iconSelector.defaultSelectedValue = this.radioSelectedUpIconTexture;
			iconSelector.setValueForState(this.radioDownIconTexture, Button.STATE_DOWN, false);
			iconSelector.setValueForState(this.radioDisabledIconTexture, Button.STATE_DISABLED, false);
			iconSelector.setValueForState(this.radioSelectedDownIconTexture, Button.STATE_DOWN, true);
			iconSelector.setValueForState(this.radioSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
			iconSelector.displayObjectProperties =
			{
				scaleX: this.scale,
				scaleY: this.scale
			};
			radio.stateToIconFunction = iconSelector.updateValue;

			radio.defaultLabelProperties.elementFormat = this.lightUIElementFormat;
			radio.disabledLabelProperties.elementFormat = this.lightUIDisabledElementFormat;
			radio.selectedDisabledLabelProperties.elementFormat = this.lightUIDisabledElementFormat;

			radio.gap = this._config.radioGap * this.scale;
			radio.minTouchWidth = this._config.radioMinTouchSize.width * this.scale;
			radio.minTouchHeight = this._config.radioMinTouchSize.height * this.scale;
			
		}

		protected function checkInitializer(check:Check):void
		{
			const iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = this.checkUpIconTexture;
			iconSelector.defaultSelectedValue = this.checkSelectedUpIconTexture;
			iconSelector.setValueForState(this.checkDownIconTexture, Button.STATE_DOWN, false);
			iconSelector.setValueForState(this.checkDisabledIconTexture, Button.STATE_DISABLED, false);
			iconSelector.setValueForState(this.checkSelectedDownIconTexture, Button.STATE_DOWN, true);
			iconSelector.setValueForState(this.checkSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
			iconSelector.displayObjectProperties =
			{
				scaleX: this.scale,
				scaleY: this.scale
			};
			check.stateToIconFunction = iconSelector.updateValue;

			check.defaultLabelProperties.elementFormat = this.lightUIElementFormat;
			check.disabledLabelProperties.elementFormat = this.lightUIDisabledElementFormat;
			check.selectedDisabledLabelProperties.elementFormat = this.lightUIDisabledElementFormat;

			check.gap = this._config.checkGap * this.scale;
			check.minTouchWidth = this._config.checkMinTouchSize.width * this.scale;
			check.minTouchHeight = this._config.checkMinTouchSize.height * this.scale;
		}

		protected function sliderInitializer(slider:Slider):void
		{
			slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_MIN_MAX;

			const skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.backgroundSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.backgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			if(slider.direction == Slider.DIRECTION_VERTICAL)
			{
				skinSelector.displayObjectProperties.width = this._config.sliderSize.width * this.scale;
				skinSelector.displayObjectProperties.height = this._config.sliderSize.height * this.scale;
			}
			else
			{
				skinSelector.displayObjectProperties.width = this._config.sliderSize.height * this.scale;
				skinSelector.displayObjectProperties.height = this._config.sliderSize.width * this.scale;
			}
			slider.minimumTrackProperties.stateToSkinFunction = skinSelector.updateValue;
			slider.maximumTrackProperties.stateToSkinFunction = skinSelector.updateValue;
		}

		protected function toggleSwitchInitializer(toggle:ToggleSwitch):void
		{
			toggle.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;

			toggle.defaultLabelProperties.elementFormat = this.lightUIElementFormat;
			toggle.onLabelProperties.elementFormat = this.selectedUIElementFormat;
		}

		protected function numericStepperInitializer(stepper:NumericStepper):void
		{
			stepper.buttonLayoutMode = NumericStepper.BUTTON_LAYOUT_MODE_SPLIT_HORIZONTAL;
			stepper.incrementButtonLabel = this._config.numericStepperIncrementLabel;
			stepper.decrementButtonLabel = this._config.numericStepperDecrementLabel;
		}

		protected function horizontalScrollBarInitializer(scrollBar:SimpleScrollBar):void
		{
			scrollBar.direction = SimpleScrollBar.DIRECTION_HORIZONTAL;
			const defaultSkin:Scale3Image = new Scale3Image(this.horizontalScrollBarThumbSkinTextures, this.scale);
			defaultSkin.width = 10 * this.scale;
			scrollBar.thumbProperties.defaultSkin = defaultSkin;
			//hScrollbarPadding.topは使わない
			scrollBar.paddingRight = this._config.hScrollbarPadding.right * this.scale;
			scrollBar.paddingBottom = this._config.hScrollbarPadding.bottom * this.scale;
			scrollBar.paddingLeft = this._config.hScrollbarPadding.left * this.scale;
		}

		protected function verticalScrollBarInitializer(scrollBar:SimpleScrollBar):void
		{
			scrollBar.direction = SimpleScrollBar.DIRECTION_VERTICAL;
			const defaultSkin:Scale3Image = new Scale3Image(this.verticalScrollBarThumbSkinTextures, this.scale);
			defaultSkin.height = 10 * this.scale;
			scrollBar.thumbProperties.defaultSkin = defaultSkin;
			//hScrollbarPadding.leftは使わない
			scrollBar.paddingTop = this._config.vScrollbarPadding.top * this.scale;
			scrollBar.paddingRight = this._config.vScrollbarPadding.right * this.scale;
			scrollBar.paddingBottom = this._config.vScrollbarPadding.bottom * this.scale;
		}

		protected function baseTextInputInitializer(input:TextInput):void
		{
			
			var config:CommonThemeConfig = this._config;
			
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.backgroundInsetSkinTextures;
			skinSelector.setValueForState(this.backgroundDisabledSkinTextures, TextInput.STATE_DISABLED);
			skinSelector.setValueForState(this.backgroundFocusedSkinTextures, TextInput.STATE_FOCUSED);
			skinSelector.displayObjectProperties =
			{
				width: config.textInputSize.width * this.scale,
				height: config.textInputSize.height * this.scale,
				textureScale: this.scale
			};
			input.stateToSkinFunction = skinSelector.updateValue;

			input.minWidth = config.textInputMinSize.width * this.scale;
			input.minHeight = config.textInputMinSize.height * this.scale;
			input.minTouchWidth = config.textInputMinTouchSize.width * this.scale;
			input.minTouchHeight = config.textInputMinTouchSize.height * this.scale;
			input.gap = config.textInputGap * this.scale;
			input.paddingTop = config.textInputPadding.top * this.scale;
			input.paddingRight = config.textInputPadding.right * this.scale;
			input.paddingBottom = config.textInputPadding.bottom * this.scale;
			input.paddingLeft = config.textInputPadding.left * this.scale;
			input.textEditorProperties.fontFamily = config.textInputFontFamily;
			input.textEditorProperties.fontSize = config.textInputFontSize * this.scale;
			input.textEditorProperties.color = config.lightTextColor;

			input.promptProperties.elementFormat = this.lightElementFormat;
		}

		protected function textInputInitializer(input:TextInput):void
		{
			this.baseTextInputInitializer(input);
		}

		protected function searchTextInputInitializer(input:TextInput):void
		{
			this.baseTextInputInitializer(input);

			var searchIcon:ImageLoader = new ImageLoader();
			searchIcon.source = this.searchIconTexture;
			searchIcon.snapToPixels = true;
			input.defaultIcon = searchIcon;
		}

		protected function numericStepperTextInputInitializer(input:TextInput):void
		{
			const backgroundSkin:Scale9Image = new Scale9Image(this.backgroundSkinTextures, this.scale);
			backgroundSkin.width = 60 * this.scale;
			backgroundSkin.height = 60 * this.scale;
			input.backgroundSkin = backgroundSkin;

			const backgroundDisabledSkin:Scale9Image = new Scale9Image(this.backgroundDisabledSkinTextures, this.scale);
			backgroundDisabledSkin.width = 60 * this.scale;
			backgroundDisabledSkin.height = 60 * this.scale;
			input.backgroundDisabledSkin = backgroundDisabledSkin;

			const backgroundFocusedSkin:Scale9Image = new Scale9Image(this.backgroundFocusedSkinTextures, this.scale);
			backgroundFocusedSkin.width = 60 * this.scale;
			backgroundFocusedSkin.height = 60 * this.scale;
			input.backgroundFocusedSkin = backgroundFocusedSkin;

			input.minWidth = this._config.numericStepperTextInputMinSize.width * this.scale;
			input.minHeight = this._config.numericStepperTextInputMinSize.height * this.scale;
			input.minTouchWidth = this._config.numericStepperTextInputMinTouchSize.width * this.scale;
			input.minTouchHeight = this._config.numericStepperTextInputMinTouchSize.height * this.scale;
			input.gap = this._config.numericStepperTextInputGap * this.scale;
			input.paddingTop = this._config.numericStepperTextInputPadding.top * this.scale;
			input.paddingRight = this._config.numericStepperTextInputPadding.right * this.scale;
			input.paddingBottom = this._config.numericStepperTextInputPadding.bottom * this.scale;
			input.paddingLeft = this._config.numericStepperTextInputPadding.left * this.scale;
			input.isEditable = false;
			input.textEditorFactory = stepperTextEditorFactory;
			input.textEditorProperties.textFormat = this.lightUICenteredTextFormat;
			input.textEditorProperties.embedFonts = true;
		}

		protected function pageIndicatorInitializer(pageIndicator:PageIndicator):void
		{
			pageIndicator.normalSymbolFactory = this.pageIndicatorNormalSymbolFactory;
			pageIndicator.selectedSymbolFactory = this.pageIndicatorSelectedSymbolFactory;
			pageIndicator.gap = this._config.pageIndicatorGap * this.scale;
			pageIndicator.paddingTop = this._config.pageIndicatorPadding.top * this.scale;
			pageIndicator.paddingRight = this._config.pageIndicatorPadding.right * this.scale;
			pageIndicator.paddingBottom = this._config.pageIndicatorPadding.bottom * this.scale;
			pageIndicator.paddingLeft = this._config.pageIndicatorPadding.left * this.scale;
			pageIndicator.minTouchWidth = this._config.pageIndicatorMinTouchSize.width * this.scale;
			pageIndicator.minTouchHeight = this._config.pageIndicatorMinTouchSize.height * this.scale;
		}

		protected function progressBarInitializer(progress:ProgressBar):void
		{
			const backgroundSkin:Scale9Image = new Scale9Image(this.backgroundSkinTextures, this.scale);
			backgroundSkin.width = 240 * this.scale;
			backgroundSkin.height = 22 * this.scale;
			progress.backgroundSkin = backgroundSkin;

			const backgroundDisabledSkin:Scale9Image = new Scale9Image(this.backgroundDisabledSkinTextures, this.scale);
			backgroundDisabledSkin.width = 240 * this.scale;
			backgroundDisabledSkin.height = 22 * this.scale;
			progress.backgroundDisabledSkin = backgroundDisabledSkin;

			const fillSkin:Scale9Image = new Scale9Image(this.buttonUpSkinTextures, this.scale);
			fillSkin.width = 8 * this.scale;
			fillSkin.height = 22 * this.scale;
			progress.fillSkin = fillSkin;

			const fillDisabledSkin:Scale9Image = new Scale9Image(this.buttonDisabledSkinTextures, this.scale);
			fillDisabledSkin.width = 8 * this.scale;
			fillDisabledSkin.height = 22 * this.scale;
			progress.fillDisabledSkin = fillDisabledSkin;
		}

		protected function headerInitializer(header:Header):void
		{
			header.minWidth = this._config.headerMinSize.width * this.scale;
			header.minHeight = this._config.headerMinSize.height * this.scale;
			header.paddingTop = this._config.headerPadding.top * this.scale;
			header.paddingRight = this._config.headerPadding.right * this.scale;
			header.paddingBottom = this._config.headerPadding.bottom * this.scale;
			header.paddingLeft = this._config.headerPadding.left * this.scale;
			header.gap = this._config.headerGap * this.scale;
			header.titleGap = this._config.headerTitleGap * this.scale;

			const backgroundSkin:TiledImage = new TiledImage(this.headerBackgroundSkinTexture, this.scale);
			backgroundSkin.width = backgroundSkin.height = 88 * this.scale;
			header.backgroundSkin = backgroundSkin;
			header.titleProperties.elementFormat = this.headerElementFormat;
		}

		protected function headerWithoutBackgroundInitializer(header:Header):void
		{
			header.minWidth = this._config.headerWithoutBackgroundMinSize.width * this.scale;
			header.minHeight = this._config.headerWithoutBackgroundMinSize.height * this.scale;
			header.paddingTop = this._config.headerWithoutBackgroundPadding.top * this.scale;
			header.paddingRight = this._config.headerWithoutBackgroundPadding.right * this.scale;
			header.paddingBottom = this._config.headerWithoutBackgroundPadding.bottom * this.scale;
			header.paddingLeft = this._config.headerWithoutBackgroundPadding.left * this.scale;

			header.titleProperties.elementFormat = this.headerElementFormat;
		}

		protected function pickerListInitializer(list:PickerList):void
		{
			var config:CommonThemeConfig = this._config;
			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				list.popUpContentManager = new CalloutPopUpContentManager();
			}
			else
			{
				const centerStage:VerticalCenteredPopUpContentManager = new VerticalCenteredPopUpContentManager();
				centerStage.marginTop = config.pickerListCenterStageMargin.top * this.scale;
				centerStage.marginRight = config.pickerListCenterStageMargin.right * this.scale;
				centerStage.marginBottom = config.pickerListCenterStageMargin.bottom * this.scale;
				centerStage.marginLeft = config.pickerListCenterStageMargin.left * this.scale;
				list.popUpContentManager = centerStage;
			}

			const layout:VerticalLayout = new VerticalLayout();
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_BOTTOM;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			layout.useVirtualLayout = true;
			layout.gap = config.pickerListLayoutGap * this.scale;
			layout.paddingTop = config.pickerListLayoutPadding.top * this.scale;
			layout.paddingRight = config.pickerListLayoutPadding.right * this.scale;
			layout.paddingBottom = config.pickerListLayoutPadding.bottom * this.scale;
			layout.paddingLeft = config.pickerListLayoutPadding.left * this.scale;
			list.listProperties.layout = layout;
			list.listProperties.verticalScrollPolicy = List.SCROLL_POLICY_ON;

			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				list.listProperties.minWidth = config.pickerListMinSizeForTablet.width * this.scale;
				list.listProperties.maxHeight = config.pickerListMinSizeForTablet.height * this.scale;
			}
			else
			{
				const backgroundSkin:Scale9Image = new Scale9Image(this.backgroundSkinTextures, this.scale);
				backgroundSkin.width = 20 * this.scale;
				backgroundSkin.height = 20 * this.scale;
				list.listProperties.backgroundSkin = backgroundSkin;
				list.listProperties.paddingTop = config.pickerListPadding.top * this.scale;
				list.listProperties.paddingRight = config.pickerListPadding.right * this.scale;
				list.listProperties.paddingBottom  = config.pickerListPadding.bottom * this.scale;
				list.listProperties.paddingLeft = config.pickerListPadding.left * this.scale;
			}

			list.listProperties.itemRendererName = COMPONENT_NAME_PICKER_LIST_ITEM_RENDERER;
		}

		protected function calloutInitializer(callout:Callout):void
		{
			const backgroundSkin:Scale9Image = new Scale9Image(this.backgroundPopUpSkinTextures, this.scale);
			//arrow size is 40 pixels, so this should be a bit larger
			backgroundSkin.width = 50 * this.scale;
			backgroundSkin.height = 50 * this.scale;
			callout.backgroundSkin = backgroundSkin;

			const topArrowSkin:Image = new Image(this.calloutTopArrowSkinTexture);
			topArrowSkin.scaleX = topArrowSkin.scaleY = this.scale;
			callout.topArrowSkin = topArrowSkin;

			const rightArrowSkin:Image = new Image(this.calloutRightArrowSkinTexture);
			rightArrowSkin.scaleX = rightArrowSkin.scaleY = this.scale;
			callout.rightArrowSkin = rightArrowSkin;

			const bottomArrowSkin:Image = new Image(this.calloutBottomArrowSkinTexture);
			bottomArrowSkin.scaleX = bottomArrowSkin.scaleY = this.scale;
			callout.bottomArrowSkin = bottomArrowSkin;

			const leftArrowSkin:Image = new Image(this.calloutLeftArrowSkinTexture);
			leftArrowSkin.scaleX = leftArrowSkin.scaleY = this.scale;
			callout.leftArrowSkin = leftArrowSkin;

			callout.paddingTop = this._config.calloutPadding.top * this.scale;
			callout.paddingRight = this._config.calloutPadding.right * this.scale;
			callout.paddingBottom = this._config.calloutPadding.bottom * this.scale;
			callout.paddingLeft = this._config.calloutPadding.left * this.scale;
		}

		protected function panelInitializer(panel:Panel):void
		{
			const backgroundSkin:Scale9Image = new Scale9Image(this.backgroundPopUpSkinTextures, this.scale);
			panel.backgroundSkin = backgroundSkin;

			panel.paddingTop = this._config.panelPadding.top * this.scale;
			panel.paddingRight = this._config.panelPadding.right * this.scale;
			panel.paddingBottom = this._config.panelPadding.bottom * this.scale;
			panel.paddingLeft = this._config.panelPadding.left * this.scale;
		}

		protected function alertInitializer(alert:Alert):void
		{
			const backgroundSkin:Scale9Image = new Scale9Image(this.backgroundPopUpSkinTextures, this.scale);
			alert.backgroundSkin = backgroundSkin;

			alert.paddingTop = this._config.alertPadding.top * this.scale;
			alert.paddingRight = this._config.alertPadding.right * this.scale;
			alert.paddingBottom = this._config.alertPadding.bottom * this.scale;
			alert.paddingLeft = this._config.alertPadding.left * this.scale;
			alert.gap = this._config.alertGap * this.scale;
			alert.maxWidth = this._config.alertMinSize.width * this.scale;
			alert.maxHeight = this._config.alertMinSize.height * this.scale;
		}

		protected function listInitializer(list:List):void
		{
			const backgroundSkin:Quad = new Quad(88 * this.scale, 88 * this.scale, this._config.listBackgroundColor.colorData);
			list.backgroundSkin = backgroundSkin;
		}

		protected function groupedListInitializer(list:GroupedList):void
		{
			const backgroundSkin:Quad = new Quad(88 * this.scale, 88 * this.scale, this._config.listBackgroundColor.colorData);
			list.backgroundSkin = backgroundSkin;
		}

		protected function scrollContainerToolbarInitializer(container:ScrollContainer):void
		{
			if(!container.layout)
			{
				const layout:HorizontalLayout = new HorizontalLayout();
				layout.paddingTop = this._config.scrollContainerToolbarLayoutPadding.top * this.scale;
				layout.paddingRight = this._config.scrollContainerToolbarLayoutPadding.right * this.scale;
				layout.paddingBottom = this._config.scrollContainerToolbarLayoutPadding.bottom * this.scale;
				layout.paddingLeft = this._config.scrollContainerToolbarLayoutPadding.left * this.scale;
				layout.gap = this._config.scrollContainerToolbarLayoutGap * this.scale;
				container.layout = layout;
			}
			container.minWidth = this._config.scrollContainerToolbarMinSize.width * this.scale;
			container.minHeight = this._config.scrollContainerToolbarMinSize.height * this.scale;

			const backgroundSkin:TiledImage = new TiledImage(this.headerBackgroundSkinTexture, this.scale);
			backgroundSkin.width = 88 * this.scale;
			backgroundSkin.height = 88 * this.scale;
			container.backgroundSkin = backgroundSkin;
		}

		protected function insetGroupedListInitializer(list:GroupedList):void
		{
			list.itemRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_ITEM_RENDERER;
			list.firstItemRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_FIRST_ITEM_RENDERER;
			list.lastItemRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_LAST_ITEM_RENDERER;
			list.singleItemRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_SINGLE_ITEM_RENDERER;
			list.headerRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_HEADER_RENDERER;
			list.footerRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_FOOTER_RENDERER;

			const layout:VerticalLayout = new VerticalLayout();
			layout.useVirtualLayout = true;
			layout.padding = this._config.insetGroupedListLayoutPadding * this.scale;
			layout.gap = this._config.insetGroupedListLayoutGap * this.scale;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			layout.manageVisibility = true;
			list.layout = layout;
		}

		protected function root_addedToStageHandler(event:Event):void
		{
			this.initializeRoot();
		}

	}
}
