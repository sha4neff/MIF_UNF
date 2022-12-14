//CODE128 служебная функция
Функция ПолучитьСимволCode128(Тбл,Индекс)
	Элемент = "" + Тбл.Получить(Индекс).Значение;
	Результат = "";
	Для А = 1 По СтрДлина(Элемент)/2 Цикл
		Результат = Результат + Символ(37 + Сред(Элемент,(А-1)*2+1,2));
	КонецЦикла;
	Возврат Результат;
КонецФункции
//CODE128 служебная функция
Процедура ДобавитьСтрокуВТЗ_НаборCodeB(Тбл,Индекс,Значение)
	НоваяСтрока = Тбл.Добавить();
	НоваяСтрока.Индекс = Индекс;
	НоваяСтрока.Значение = Значение;
КонецПроцедуры
//CODE128 Строка для печати
Функция CODE128Строка(Знач Штрихкод) Экспорт
	СЗ_СимволыБарКода=Новый СписокЗначений();
										  // ID		CODEA	CODEB	CODEC
	СЗ_СимволыБарКода.Добавить("212222"); // 0		Пробел	Пробел	00
	СЗ_СимволыБарКода.Добавить("222122"); // 1		!		!		01
	СЗ_СимволыБарКода.Добавить("222221"); // 2		"		"		02
	СЗ_СимволыБарКода.Добавить("121223"); // 3		#		#		03
	СЗ_СимволыБарКода.Добавить("121322"); // 4		$		$		04
	СЗ_СимволыБарКода.Добавить("131222"); // 5		%		%		05
	СЗ_СимволыБарКода.Добавить("122213"); // 6		&		&		06
	СЗ_СимволыБарКода.Добавить("122312"); // 7		'		'		07
	СЗ_СимволыБарКода.Добавить("132212"); // 8		(		(		08
	СЗ_СимволыБарКода.Добавить("221213"); // 9		)		)		09
	СЗ_СимволыБарКода.Добавить("221312"); // 10		*		*		10
	СЗ_СимволыБарКода.Добавить("231212"); // 11		+		+		11
	СЗ_СимволыБарКода.Добавить("112232"); // 12		,		,		12
	СЗ_СимволыБарКода.Добавить("122132"); // 13		-		-		13
	СЗ_СимволыБарКода.Добавить("122231"); // 14		.		.		14
	СЗ_СимволыБарКода.Добавить("113222"); // 15		/		/		15
	СЗ_СимволыБарКода.Добавить("123122"); // 16		0		0		16
	СЗ_СимволыБарКода.Добавить("123221"); // 17		1		1		17		
	СЗ_СимволыБарКода.Добавить("223211"); // 18		2		2		18
	СЗ_СимволыБарКода.Добавить("221132"); // 19		3		3		19
	СЗ_СимволыБарКода.Добавить("221231"); // 20		4		4		20
	СЗ_СимволыБарКода.Добавить("213212"); // 21		5		5		21
	СЗ_СимволыБарКода.Добавить("223112"); // 22		6		6		22
	СЗ_СимволыБарКода.Добавить("312131"); // 23		7		7		23
	СЗ_СимволыБарКода.Добавить("311222"); // 24		8		8		24
	СЗ_СимволыБарКода.Добавить("321122"); // 25		9		9		25
	СЗ_СимволыБарКода.Добавить("321221"); // 26		:		:		26
	СЗ_СимволыБарКода.Добавить("312212"); // 27		);		);		27
	СЗ_СимволыБарКода.Добавить("322112"); // 28		<		<		28
	СЗ_СимволыБарКода.Добавить("322211"); // 29		=		=		29
	СЗ_СимволыБарКода.Добавить("212123"); // 30		>		>		30
	СЗ_СимволыБарКода.Добавить("212321"); // 31		?		?		31
	СЗ_СимволыБарКода.Добавить("232121"); // 32		@		@		32
	СЗ_СимволыБарКода.Добавить("111323"); // 33		A		A		33
	СЗ_СимволыБарКода.Добавить("131123"); // 34		B		B		34
	СЗ_СимволыБарКода.Добавить("131321"); // 35		C		C		35
	СЗ_СимволыБарКода.Добавить("112313"); // 36		D		D		36
	СЗ_СимволыБарКода.Добавить("132113"); // 37		E		E		37
	СЗ_СимволыБарКода.Добавить("132311"); // 38		F		F		38
	СЗ_СимволыБарКода.Добавить("211313"); // 39		G		G		39
	СЗ_СимволыБарКода.Добавить("231113"); // 40		H		H		40
	СЗ_СимволыБарКода.Добавить("231311"); // 41		I		I		41
	СЗ_СимволыБарКода.Добавить("112133"); // 42		J		J		42
	СЗ_СимволыБарКода.Добавить("112331"); // 43		K		K		43
	СЗ_СимволыБарКода.Добавить("132131"); // 44		L		L		44
	СЗ_СимволыБарКода.Добавить("113123"); // 45		M		M		45
	СЗ_СимволыБарКода.Добавить("113321"); // 46		N		N		46
	СЗ_СимволыБарКода.Добавить("133121"); // 47		O		O		47
	СЗ_СимволыБарКода.Добавить("313121"); // 48		P		P		48
	СЗ_СимволыБарКода.Добавить("211331"); // 49		Q		Q		49
	СЗ_СимволыБарКода.Добавить("231131"); // 50		R		R		50
	СЗ_СимволыБарКода.Добавить("213113"); // 51		S		S		51
	СЗ_СимволыБарКода.Добавить("213311"); // 52		T		T		52
	СЗ_СимволыБарКода.Добавить("213131"); // 53		U		U		53
	СЗ_СимволыБарКода.Добавить("311123"); // 54		V		V		54
	СЗ_СимволыБарКода.Добавить("311321"); // 55		W		W		55
	СЗ_СимволыБарКода.Добавить("331121"); // 56		X		X		56
	СЗ_СимволыБарКода.Добавить("312113"); // 57		Y		Y		57
	СЗ_СимволыБарКода.Добавить("312311"); // 58		Z		Z		58
	СЗ_СимволыБарКода.Добавить("332111"); // 59		[		[		59
	СЗ_СимволыБарКода.Добавить("314111"); // 60		\		\		60
	СЗ_СимволыБарКода.Добавить("221411"); // 61		]		]		61
	СЗ_СимволыБарКода.Добавить("431111"); // 62		^		^		62
	СЗ_СимволыБарКода.Добавить("111224"); // 63		_		_		63
	СЗ_СимволыБарКода.Добавить("111422"); // 64		NUL		`		64
	СЗ_СимволыБарКода.Добавить("121124"); // 65		SOH		a		65
	СЗ_СимволыБарКода.Добавить("121421"); // 66		STX		b		66
	СЗ_СимволыБарКода.Добавить("141122"); // 67		ETX		с		67
	СЗ_СимволыБарКода.Добавить("141221"); // 68		EOT		d		68
	СЗ_СимволыБарКода.Добавить("112214"); // 69		ENQ		e		69
	СЗ_СимволыБарКода.Добавить("112412"); // 70		ASK		f		70
	СЗ_СимволыБарКода.Добавить("122114"); // 71		BEL		g		71
	СЗ_СимволыБарКода.Добавить("122411"); // 72		BS		h		72
	СЗ_СимволыБарКода.Добавить("142112"); // 73		HT		i		73
	СЗ_СимволыБарКода.Добавить("142211"); // 74		LF		j		74
	СЗ_СимволыБарКода.Добавить("241211"); // 75		VT		k		75
	СЗ_СимволыБарКода.Добавить("221114"); // 76		FF		l		76
	СЗ_СимволыБарКода.Добавить("413111"); // 77		CR		m		77
	СЗ_СимволыБарКода.Добавить("241112"); // 78		SO		n		78
	СЗ_СимволыБарКода.Добавить("134111"); // 79		SI		o		79
	СЗ_СимволыБарКода.Добавить("111242"); // 80		DLE		p		80
	СЗ_СимволыБарКода.Добавить("121142"); // 81		DC1		q		81
	СЗ_СимволыБарКода.Добавить("121241"); // 82		DC2		r		82
	СЗ_СимволыБарКода.Добавить("114212"); // 83		DC3		s		83
	СЗ_СимволыБарКода.Добавить("124112"); // 84		DC4		t		84
	СЗ_СимволыБарКода.Добавить("124211"); // 85		NAK		u		85
	СЗ_СимволыБарКода.Добавить("411212"); // 86		SYN		v		86
	СЗ_СимволыБарКода.Добавить("421112"); // 87		ETB		w		87
	СЗ_СимволыБарКода.Добавить("421211"); // 88		CAN		x		88
	СЗ_СимволыБарКода.Добавить("212141"); // 89		EM		y		89
	СЗ_СимволыБарКода.Добавить("214121"); // 90		SUB		z		90
	СЗ_СимволыБарКода.Добавить("412121"); // 91		ESC		{		91
	СЗ_СимволыБарКода.Добавить("111143"); // 92		FS		| 		92
	СЗ_СимволыБарКода.Добавить("111341"); // 93		GS		}		93
	СЗ_СимволыБарКода.Добавить("131141"); // 94		RS		~		94
	СЗ_СимволыБарКода.Добавить("114113"); // 95		US		DEL		95		
	СЗ_СимволыБарКода.Добавить("114311"); // 96		FNC3	FNC3	96
	СЗ_СимволыБарКода.Добавить("411113"); // 97		FNC2	FNC2	97
	СЗ_СимволыБарКода.Добавить("411311"); // 98		SHIFTB	SHIFTA	98
	СЗ_СимволыБарКода.Добавить("113141"); // 99		CODEC	CODEC	99
	СЗ_СимволыБарКода.Добавить("114131"); // 100	CODEB	FNC4	CODEB
	СЗ_СимволыБарКода.Добавить("311141"); // 101	FNC4	CODEA	CODEA
	СЗ_СимволыБарКода.Добавить("411131"); // 102	FNC1	FNC1	FNC1
								   		  // Старт-коды
	СЗ_СимволыБарКода.Добавить("211412"); // 103	CODEA
	СЗ_СимволыБарКода.Добавить("211214"); // 104	CODEB
	СЗ_СимволыБарКода.Добавить("211232"); // 105	CODEC
	СЗ_СимволыБарКода.Добавить("23311121");//106	Стоп-код
	
	ТЗ_НаборCodeB=Новый ТаблицаЗначений();
	ТЗ_НаборCodeB.Колонки.Добавить("Индекс",Новый ОписаниеТипов("Число"));
	ТЗ_НаборCodeB.Колонки.Добавить("Значение",Новый ОписаниеТипов("Строка"));
	
	ТЗ_НаборCodeC=Новый ТаблицаЗначений();
	ТЗ_НаборCodeC.Колонки.Добавить("Индекс",Новый ОписаниеТипов("Число"));
	ТЗ_НаборCodeC.Колонки.Добавить("Значение",Новый ОписаниеТипов("Строка"));
	Для А = 0 По 99 Цикл
		НоваяСтрока = ТЗ_НаборCodeC.Добавить();
		НоваяСтрока.Индекс = А;
		НоваяСтрока.Значение = Прав("0"+А,2);
	КонецЦикла;
	
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,0," ");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,1,"!");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,2,"""");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,3,"#");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,4,"$");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,5,"%");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,6,"&");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,7,"'");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,8,"(");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,9,")");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,10,"*");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,11,"+");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,12,",");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,13,"-");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,14,".");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,15,"/");
	Для А = 0 По 9 Цикл
		ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,А+16,""+А);
	КонецЦикла;
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,26,":");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,27,";");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,28,"<");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,29,"=");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,30,">");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,31,"?");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,32,"@");
	Б = 33;
	Для А = КодСимвола("A") По КодСимвола("Z") Цикл
		ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,Б, Символ(А));
		Б = Б + 1;
	КонецЦикла;
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,59,"[");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,60,"\");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,61,"]");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,62,"^");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,63,"_");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,64,"`");
	Б = 65;
	Для А = КодСимвола("a") По КодСимвола("z") Цикл
		ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,Б,Символ(А));
		Б = Б + 1;
	КонецЦикла;
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,91,"{");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,92,"|");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,93,"}");
	ДобавитьСтрокуВТЗ_НаборCodeB(ТЗ_НаборCodeB,94,"~");	
	ТекущийНабор = "";
	СЗ_НомернаяПоследовательность = Новый СписокЗначений;	
	ТекПоз = 1;
	Пока ТекПоз <= СтрДлина(Штрихкод) Цикл
		Отбор = Новый Структура();
		Отбор.Вставить("Значение" , "" + Сред(Штрихкод , ТекПоз , 2));
		Массив = ТЗ_НаборCodeC.НайтиСтроки(Отбор);
		Если Массив.Количество() > 0 Тогда // последовательность из двух цифр - CODE C
			Если ТекущийНабор <> 105 Тогда
				Если ПустаяСтрока(ТекущийНабор) Тогда
					СЗ_НомернаяПоследовательность.Добавить(105);
				Иначе
					СЗ_НомернаяПоследовательность.Добавить(99);
				КонецЕсли;
				ТекущийНабор = 105;
			КонецЕсли;
			СЗ_НомернаяПоследовательность.Добавить(Массив.Получить(0).Индекс);
			ТекПоз = ТекПоз + 2;
			Продолжить;
		КонецЕсли;
		Отбор = Новый Структура();
		Отбор.Вставить("Значение" , "" + Сред(Штрихкод,ТекПоз,1));
		Массив = ТЗ_НаборCodeB.НайтиСтроки(Отбор);
		Если Массив.Количество() > 0 Тогда // последовательность CODE B
			Если ТекущийНабор <> 104 Тогда
				Если ПустаяСтрока(ТекущийНабор) Тогда
					СЗ_НомернаяПоследовательность.Добавить(104);
				Иначе
					СЗ_НомернаяПоследовательность.Добавить(100);
				КонецЕсли;
				ТекущийНабор = 104;
			КонецЕсли;                   
			СЗ_НомернаяПоследовательность.Добавить(Массив.Получить(0).Индекс);
			ТекПоз = ТекПоз + 1;
			Продолжить;
		КонецЕсли;
		Сообщить("В указанном значении присутствуют неразрешенные символы. Для создания штрих-кода не используйте кирилические и спец.символы.");
		Возврат "";
	КонецЦикла;	
	ШтрихКод = "";
	ДляРасчетаКонтрольногоЧисла = 0;
	Для А = 0 По СЗ_НомернаяПоследовательность.Количество()-1 Цикл
		Номер = СЗ_НомернаяПоследовательность.Получить(А).Значение;
		ШтрихКод = ШтрихКод + ПолучитьСимволCode128(СЗ_СимволыБарКода,Номер);
		Коэффициент = ?(А = 0 , 1 , А);
		ДляРасчетаКонтрольногоЧисла = ДляРасчетаКонтрольногоЧисла + (Номер * Коэффициент);
	КонецЦикла;
	КонтрольноеЧисло = ДляРасчетаКонтрольногоЧисла%103;
	ШтрихКод = ШтрихКод + ПолучитьСимволCode128(СЗ_СимволыБарКода,КонтрольноеЧисло);
	ШтрихКод = ШтрихКод + ПолучитьСимволCode128(СЗ_СимволыБарКода,106);	
	Возврат ШтрихКод;	
КонецФункции
//CODE128 Строка для печати
Процедура CODE128СтрокаТермо(Знач Штрихкод,Запись) Экспорт
	КоличествоЦифр=СтрДлина(Штрихкод);
	Если КоличествоЦифр/2<>Цел(КоличествоЦифр/2) Тогда
		Возврат;
	КонецЕсли;                                                   
	Запись.ЗаписатьБайт(29); Запись.ЗаписатьБайт(104); Запись.ЗаписатьБайт(75);	// Установка высоты ШК
    Запись.ЗаписатьБайт(29); Запись.ЗаписатьБайт(107); Запись.ЗаписатьБайт(73);	// Инициализация ШК
	Запись.ЗаписатьБайт(2+(КоличествоЦифр/2)); // Длина
	Запись.ЗаписатьБайт(123); Запись.ЗаписатьБайт(67); // Выбор типа Type C
	Для А=1 По КоличествоЦифр/2 Цикл
		Запись.ЗаписатьБайт(Число(Лев(Штрихкод,2)));
		Штрихкод=Прав(Штрихкод,СтрДлина(Штрихкод)-2);
	КонецЦикла;
КонецПроцедуры

Функция ПолучитьШК_Принтера(Принтер) Экспорт
	Возврат "302"+Принтер.Код;
КонецФункции
