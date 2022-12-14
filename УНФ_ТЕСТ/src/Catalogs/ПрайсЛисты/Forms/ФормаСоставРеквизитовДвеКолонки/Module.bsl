#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПрайсЛист.ПредставлениеНоменклатуры.Загрузить(Параметры.ПредставлениеНоменклатуры.Выгрузить());
	ПрайсЛист.ПредставлениеОстатков = Параметры.ПредставлениеОстатков;
	ПрайсЛист.ПечатьПрайсЛиста = Параметры.ПечатьПрайсЛиста;
	
	ПрайсЛист.КоличествоКолонок = Параметры.КоличествоКолонок;
	ПрайсЛист.КартинкаШирина = Параметры.КартинкаШирина;
	ПрайсЛист.КартинкаВысота = Параметры.КартинкаВысота;
	ПрайсЛист.ИзменятьРазмерПропорционально = Параметры.ИзменятьРазмерПропорционально;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КартинкаВысота", "Доступность",
		Не ПрайсЛист.ИзменятьРазмерПропорционально);
	
	ЭтоДиафильм = (ПрайсЛист.ПечатьПрайсЛиста = Перечисления.ВариантыПечатиПрайсЛиста.Диафильм);
	
	Для каждого Строка Из ПрайсЛист.ПредставлениеНоменклатуры Цикл
		
		Если Строка.РеквизитНоменклатуры = "Артикул" Тогда 
			
			КодАртикул = ?(Строка.Использование, "Артикул", "Код");
			
		КонецЕсли;
		
		Если Строка.Использование Тогда
			
			Если Строка.РеквизитНоменклатуры = "Наименование"
				ИЛИ Строка.РеквизитНоменклатуры = "НаименованиеПолное" Тогда
				
				Представление = Строка.РеквизитНоменклатуры;
				
			ИначеЕсли Строка.РеквизитНоменклатуры = "Комментарий" Тогда
				
				Представление = "Описание";
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если Строка.РеквизитНоменклатуры = "Характеристика"
			И ЭтоДиафильм Тогда
			
			ВыводитьХарактеристики = Строка.Использование;
			
		КонецЕсли;
		
		Если Строка.РеквизитНоменклатуры = "ПризнакНовинка" Тогда
			
			ВыводитьПризнакНовинка = Строка.Использование;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если НЕ ЭтоДиафильм Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтраницаКартинка", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаНастройкаКолонок", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Страницы", "ОтображениеСтраниц", ОтображениеСтраницФормы.Нет);
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаХарактеристики", "Видимость", ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристики") И ЭтоДиафильм);
	
	РедактированиеДоступно = ПравоДоступа("Редактирование", Метаданные.Справочники.ПрайсЛисты);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Страницы", "ТолькоПросмотр", НЕ РедактированиеДоступно);
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КодАртикулПриИзменении(Элемент)
	
	МассивСтрок = ПрайсЛист.ПредставлениеНоменклатуры.НайтиСтроки(Новый Структура("РеквизитНоменклатуры", "Код"));
	МассивСтрок[0].Использование = (КодАртикул = "Код");
	
	МассивСтрок = ПрайсЛист.ПредставлениеНоменклатуры.НайтиСтроки(Новый Структура("РеквизитНоменклатуры", "Артикул"));
	МассивСтрок[0].Использование = (КодАртикул = "Артикул");
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПриИзменении(Элемент)
	
	МассивСтрок = ПрайсЛист.ПредставлениеНоменклатуры.НайтиСтроки(Новый Структура("РеквизитНоменклатуры",
		"Наименование"));
	МассивСтрок[0].Использование = (Представление = "Наименование");
	
	МассивСтрок = ПрайсЛист.ПредставлениеНоменклатуры.НайтиСтроки(Новый Структура("РеквизитНоменклатуры",
		"НаименованиеПолное"));
	МассивСтрок[0].Использование = (Представление = "НаименованиеПолное");
	
	МассивСтрок = ПрайсЛист.ПредставлениеНоменклатуры.НайтиСтроки(Новый Структура("РеквизитНоменклатуры",
		"Комментарий"));
	МассивСтрок[0].Использование = (Представление = "Описание");
	
КонецПроцедуры

&НаКлиенте
Процедура КартинкаШиринаПриИзменении(Элемент)
	
	Если ПрайсЛист.ИзменятьРазмерПропорционально Тогда
		
		ПрайсЛист.КартинкаВысота = ПрайсЛист.КартинкаШирина * 5;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрайсЛистИзменятьРазмерПропорциональноПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КартинкаВысота", "Доступность",
		Не ПрайсЛист.ИзменятьРазмерПропорционально);
	
	Если ПрайсЛист.ИзменятьРазмерПропорционально Тогда
		
		ПрайсЛист.КартинкаВысота = ПрайсЛист.КартинкаШирина * 5;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьХарактеристикиПриИзменении(Элемент)
	
	МассивСтрок = ПрайсЛист.ПредставлениеНоменклатуры.НайтиСтроки(Новый Структура("РеквизитНоменклатуры",
		"Характеристика"));
	МассивСтрок[0].Использование = ВыводитьХарактеристики;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьПризнакНовинкаПриИзменении(Элемент)
	
	МассивСтрок = ПрайсЛист.ПредставлениеНоменклатуры.НайтиСтроки(Новый Структура("РеквизитНоменклатуры",
		"ПризнакНовинка"));
	МассивСтрок[0].Использование = ВыводитьПризнакНовинка;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	МассивСтрок = ПрайсЛист.ПредставлениеНоменклатуры.НайтиСтроки(Новый Структура("Использование", Истина));
	Отказ = (МассивСтрок.Количество() = 0);
	Если Отказ Тогда
		
		ТекстОшибки = НСтр("ru ='Необходимо выбрать минимум одно поле...'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
		
	Иначе
		
		ПараметрыЗакрытия = Новый Структура;
		ПараметрыЗакрытия.Вставить("РезультатЗакрытия", КодВозвратаДиалога.ОК);
		ПараметрыЗакрытия.Вставить("ПредставлениеНоменклатуры", ПрайсЛист.ПредставлениеНоменклатуры);
		ПараметрыЗакрытия.Вставить("ПредставлениеОстатков", ПрайсЛист.ПредставлениеОстатков);
		ПараметрыЗакрытия.Вставить("КоличествоКолонок", ПрайсЛист.КоличествоКолонок);
		ПараметрыЗакрытия.Вставить("КартинкаШирина", ПрайсЛист.КартинкаШирина);
		ПараметрыЗакрытия.Вставить("КартинкаВысота", ПрайсЛист.КартинкаВысота);
		ПараметрыЗакрытия.Вставить("ИзменятьРазмерПропорционально", ПрайсЛист.ИзменятьРазмерПропорционально);
		
		Закрыть(ПараметрыЗакрытия);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
