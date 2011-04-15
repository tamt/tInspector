package cn.itamt.utils
{

	/**
	 * 针对Function的一些工具
	 * @author tamt
	 */
	public class FunctionTool
	{

		// bind (== partial)
		public static function bind(f:Function, ... args):Function
		{
			return function(... rest):* {
				return f.apply(null, args.concat(rest));
			};
		}

		/**
		 * 函数的柯灵化（curry），实现函数递归调用。
		 * @example
		 * 	<code>
		 * 		function sum(a:int, b:int, c:int):int{
		 * 			return a+b+c;
		 * 		}
		 * 		var curriedSum:Function = FunctionTool.curry(sum);
		 * 		curriedSum(1,2,3);		//6
		 * 		curriedSum(1)(2,3);		//6
		 * 		curriedSum(1,2)(3);		//6
		 * 		curriedSum(1)(2)(3);	//6
		 * 	</code>
		 * @see	http://rest-term.com/archives/2857/
		 */
		public static function curry(f:Function, ... rest):Function
		{
			function currying(args:Array):* {
				if (args.length >= f.length) {
					return f.apply(null, args);
				}
				return function(... more):* {
					return currying(args.concat(more));
				};
			}
			return currying(rest);
		}

	}
}
