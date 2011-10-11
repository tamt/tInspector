package msc.revision
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;

	public class mPreloader extends Sprite
	{
		private var main : Loader;
		private var rootPath : String;

		public function mPreloader()
		{
			super();

			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(evt : Event = null) : void
		{
			rootPath = (this.loaderInfo.url.slice(0, this.loaderInfo.url.lastIndexOf('/')));

			if (this.loaderInfo.url.indexOf('file:///') != 0)
			{
				mFileRevisionManager.getInstance().enable = true;

				mFileRevisionManager.getInstance().setFileRootPath(rootPath);
				
				//初始化
				if (this.loaderInfo.parameters.cur)
				{
					mFileRevisionManager.getInstance().init(this.loaderInfo.parameters.cur);
				}
				else
				{
					mFileRevisionManager.getInstance().init();
				}

				mFileRevisionManager.getInstance().start();
				mFileRevisionManager.getInstance().addEventListener(Event.COMPLETE, onLoadRevision);
				mFileRevisionManager.getInstance().addEventListener(ErrorEvent.ERROR, onLoadRevisionError);
			}
			else
			{
				mFileRevisionManager.getInstance().enable = false;
				this.loadMain();
			}
		}

		private function onLoadRevision(evt : Event) : void
		{
			loadMain();
		}

		private function onLoadRevisionError(evt : ErrorEvent) : void
		{
			trace('加载版本文件出错：' + evt.text);

			loadMain();
		}

		private function loadMain() : void
		{
			main = new Loader();
			main.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoading);
			main.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);

			main.load(mFileRevisionManager.getInstance().getFileUrlRequest(rootPath + '/Main.swf'));
		}

		private function onLoading(evt : ProgressEvent) : void
		{
		}

		private function onComplete(evt : Event) : void
		{
			this.stage.addChild(main.content);

			this.parent.removeChild(this);
		}
	}
}