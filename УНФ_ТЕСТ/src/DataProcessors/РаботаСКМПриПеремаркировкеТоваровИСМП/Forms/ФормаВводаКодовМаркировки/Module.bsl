#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(Объект, Параметры);
	Объект.ВыбранныйКодМаркировки      = Параметры.КодМаркировки;
	Объект.ВыбранныйНовыйКодМаркировки = Параметры.НовыйКодМаркировки;
	
	Если Не ПравоДоступа("Редактирование", Метаданные.Документы.ПеремаркировкаТоваровИСМП) Тогда
		Объект.БлокировкаРедактированияСтарогоКода = Истина;
		Объект.БлокировкаРедактированияНовогоКода  = Истина;
	КонецЕсли;
	
	Если Параметры.ДанныеВыбораПоМаркируемойПродукции <> Неопределено Тогда
		ДанныеВыбора              = Параметры.ДанныеВыбораПоМаркируемойПродукции;
		Объект.ШаблонЭтикетки     = ДанныеВыбора.ШаблонЭтикетки;
		Объект.Шаблон             = ДанныеВыбора.ШаблонМаркировки;
		Объект.СразуНаПринтер     = ДанныеВыбора.СразуНаПринтер;
	КонецЕсли;
	
	СтруктураПолей = СтруктураПолейПоРежиму();
	УстановитьПараметрыВыбораШтрихкодыУпаковок(СтруктураПолей);
	СтруктураПолей = СтруктураПолейПоРежиму(Истина);
	УстановитьПараметрыВыбораШтрихкодыУпаковок(СтруктураПолей);
	
	ОпределитьТекущийШаг(ЭтотОбъект);
	
	УстановитьДоступностьЭлементовФормы();
	
	ИнтеграцияИСМПКлиентСервер.УстановитьКартинкуСканированияКодаПоВидуПродукции(Элементы.ДекорацияКартинка, Объект.ВидПродукции);
	ИнтеграцияИСМПКлиентСервер.УстановитьКартинкуСканированияКодаПоВидуПродукции(Элементы.ДекорацияНоваяКартинка, Объект.ВидПродукции);
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВладелецФормы = Неопределено Тогда
		ТекстСообщения = НСтр("ru='Непосредственное открытие этой формы не предусмотрено.
			                      |Открытие формы производится из документа Перемаркировка товаров ИС МП.'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
	
	СобытияФормИСМПКлиент.ОпределитьИспользованиеХарактеристик(
		ЭтотОбъект,
		Объект,
		"Номенклатура", "ХарактеристикиИспользуются");
	СобытияФормИСМПКлиент.ОпределитьИспользованиеХарактеристик(
		ЭтотОбъект,
		Объект,
		"НоваяНоменклатура", "НоваяХарактеристикаИспользуется");
	
	ОбновитьПредставленияНоменклатуры(ЭтотОбъект);
	ЗаполнитьТоварыИсточник();
	
	ПроверкаПричиныПеремаркировки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	// Конец ПодключаемоеОборудование
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Объект.ХарактеристикиИспользуются Тогда
		ПроверяемыеРеквизиты.Добавить("Характеристика");
	КонецЕсли;
	
	Если Объект.РезультатВзятьИзПула Тогда
		Если Не ЗначениеЗаполнено(Объект.НоваяНоменклатура) Тогда
			ТекстСообщения = НСтр("ru = 'Необходимо заполнить поле ""Номенклатура""'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "НовоеПредставление", , Отказ);
		КонецЕсли;
		Если Объект.НоваяХарактеристикаИспользуется И Не ЗначениеЗаполнено(Объект.НоваяХарактеристика) Тогда
			ТекстСообщения = НСтр("ru = 'Необходимо заполнить поле ""Характеристика""'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "НовоеПредставление", , Отказ);
		КонецЕсли;
	Иначе
		Если ЗначениеЗаполнено(Объект.КодМаркировки)
			И Объект.КодМаркировки = Объект.НовыйКодМаркировки Тогда
			ТекстСообщения = НСтр("ru = 'Новый код маркировки должен отличаться от старого'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		КонецЕсли;
	КонецЕсли;
	
	МассивСтруктурПоиска = Новый Массив();
	
	Если Объект.КодМаркировки <> Объект.ВыбранныйКодМаркировки Тогда
		МассивСтруктурПоиска.Добавить(Новый Структура("КодМаркировки",      Объект.КодМаркировки));
		МассивСтруктурПоиска.Добавить(Новый Структура("НовыйКодМаркировки", Объект.КодМаркировки));
	КонецЕсли;
	
	Если Объект.НовыйКодМаркировки <> Объект.ВыбранныйНовыйКодМаркировки Тогда
		МассивСтруктурПоиска.Добавить(Новый Структура("КодМаркировки",      Объект.НовыйКодМаркировки));
		МассивСтруктурПоиска.Добавить(Новый Структура("НовыйКодМаркировки", Объект.НовыйКодМаркировки));
	КонецЕсли;
	
	ТекстСообщения = "";
	
	Для Каждого СтруктураПоиска Из МассивСтруктурПоиска Цикл
		ПоискСтрок = Объект.ТоварыИсточник.НайтиСтроки(СтруктураПоиска);
		Если ПоискСтрок.Количество() <> 0 Тогда
			Отказ = Истина;
			
			Для Каждого КлючИЗначение Из СтруктураПоиска Цикл
				ТекстСообщения = ТекстСообщения + Символы.ПС + СтрШаблон(
					НСтр("ru = 'Код маркировки %1 уже добавлен в документ'"), КлючИЗначение.Значение);
			КонецЦикла;
			
		КонецЕсли;
	КонецЦикла;
	
	ВывестиСообщениеНаСтраницеВводаКодаМаркировки(СокрЛП(ТекстСообщения));
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ТекущаяСтраница", Элементы.СтраницыДанных.ТекущаяСтраница);
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ПараметрыСканирования = ПараметрыСканированияШтрихкода(Элементы.СтраницыДанных.ТекущаяСтраница);
	СобытияФормИСКлиент.ВнешнееСобытиеПолученыШтрихкоды(
		ОповещениеПриЗавершении, ЭтотОбъект, Источник, Событие, Данные, ПараметрыСканирования);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КодМаркировкиПриИзменении(Элемент)
	
	КодМаркировкиПриИзмененииСервер();
	ОбновитьПараметрыПослеИзмененияКодаМаркировки();
	ОбновитьКэшМаркируемойПродукции();
	
КонецПроцедуры
	
&НаКлиенте
Процедура НовоеПредставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если Объект.БлокировкаРедактированияНовогоКода Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПолей = СтруктураПолейПоРежиму(Истина);
	
	ОбработкаНавигационнойСсылкиНоменклатуры(
		НавигационнаяСсылкаФорматированнойСтроки, СтруктураПолей, СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылкиНоменклатуры(НавигационнаяСсылка, СтруктураПолей, СтандартнаяОбработка)
		
	ДополнительныеПараметрыОповещения = Новый Структура();
	ДополнительныеПараметрыОповещения.Вставить("НавигационнаяСсылка", НавигационнаяСсылка);
	ДополнительныеПараметрыОповещения.Вставить("СтруктураПолей",      СтруктураПолей);
	ДополнительныеПараметрыОповещения.Вставить("Контекст",            Объект);
	
	ОписаниеВыборЗначения = Новый ОписаниеОповещения(
		"ОповещениеВыборПоНавигационнойСсылкеВФормеВводаКодаМаркировки", ЭтотОбъект, ДополнительныеПараметрыОповещения);
	
	Если НавигационнаяСсылка = "ВыбратьНоменклатуру" Тогда
		
		СобытияФормИСКлиентПереопределяемый.ПриНачалеВыбораНоменклатуры(
			ЭтотОбъект, Объект.ВидПродукции, СтандартнаяОбработка, ОписаниеВыборЗначения);
		
	ИначеЕсли НавигационнаяСсылка = "ВыбратьХарактеристику" Тогда
		
		СобытияФормИСМПКлиентПереопределяемый.ПриНачалеВыбораХарактеристики(
			ЭтотОбъект, Объект, СтандартнаяОбработка, СтруктураПолей.Номенклатура, ОписаниеВыборЗначения);
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если Объект.БлокировкаРедактированияСтарогоКода Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПолей = СтруктураПолейПоРежиму();
	
	ОбработкаНавигационнойСсылкиНоменклатуры(НавигационнаяСсылкаФорматированнойСтроки, СтруктураПолей, СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура НовыйКодМаркировкиПриИзменении(Элемент)
	
	КодМаркировкиПриИзмененииСервер();
	ОбновитьПараметрыПослеИзмененияКодаМаркировки();
	ОбновитьКэшМаркируемойПродукции();
	
КонецПроцедуры

&НаКлиенте
Процедура ПричинаПеремаркировкиПриИзменении(Элемент)
	ПроверкаПричиныПеремаркировки();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	КомандаДалее();
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	КомандаНазад();
	
КонецПроцедуры

&НаКлиенте
Процедура РаспечататьНовыйКодМаркировки(Команда)
	
	Объект.РезультатВзятьИзПула = Истина;
	Отказ = Ложь;
	ЗавершитьВвод(Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	
	ОчиститьСообщения();
	
	ШтрихкодированиеИСКлиентПереопределяемый.ПоказатьВводШтрихкода(
		Новый ОписаниеОповещения("РучнойВводШтрихкодаЗавершение", ЭтотОбъект, Элементы.СтраницыДанных.ТекущаяСтраница));
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьКэшМаркируемойПродукции()
	Оповестить(
		ИнтеграцияИСКлиентСервер.ИмяСобытияОбновитьКэшМаркируемойПродукции(ИнтеграцияИСМПКлиентСервер.ИмяПодсистемы()),
		ВладелецФормы);
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьВвод(Отказ=Ложь, ЗакрытьФорму=Ложь)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	Если Объект.РезультатВзятьИзПула Тогда
		
		СтруктураПечатиЭтикетки                    = ПечатьЭтикетокИСМПКлиентСервер.СтруктураПечатиЭтикетки();
		СтруктураПечатиЭтикетки.Организация        = ВладелецФормы.Объект.Организация;
		СтруктураПечатиЭтикетки.ВидПродукции       = Объект.ВидПродукции;
		СтруктураПечатиЭтикетки.Номенклатура       = Объект.НоваяНоменклатура;
		СтруктураПечатиЭтикетки.Характеристика     = Объект.НоваяХарактеристика;
		СтруктураПечатиЭтикетки.ШтрихкодУпаковки   = Объект.КодМаркировки;
		СтруктураПечатиЭтикетки.СпособВводаВОборот = Объект.СпособВводаВОборот;
		СтруктураПечатиЭтикетки.Шаблон             = Объект.Шаблон;
		СтруктураПечатиЭтикетки.Серия              = Объект.Серия;
		СтруктураПечатиЭтикетки.Количество         = 1;
		СтруктураПечатиЭтикетки.МаркировкаОстатков = Объект.МаркировкаОстатков;
		
		ОписаниеОповещенияРаспечататьНовыйКодЗавершение = Новый ОписаниеОповещения(
			"РаспечататьНовыйКодЗавершение", ЭтотОбъект);
		
		СтруктураПараметров = ПечатьЭтикетокИСМПКлиент.СтруктураПараметровПечатиНовогоКодаМаркировки(
			СтруктураПечатиЭтикетки, ЭтотОбъект, ОписаниеОповещенияРаспечататьНовыйКодЗавершение);
		
		СтруктураПараметров.Шаблон                = Объект.Шаблон;
		СтруктураПараметров.СразуНаПринтер        = Объект.СразуНаПринтер;
		СтруктураПараметров.ШаблонЭтикетки        = Объект.ШаблонЭтикетки;
		СтруктураПараметров.ВидПродукции          = Объект.ВидПродукции;
		СтруктураПараметров.Номенклатура          = Объект.НоваяНоменклатура;
		СтруктураПараметров.Характеристика        = Объект.НоваяХарактеристика;
		СтруктураПараметров.Серия                 = Объект.Серия;
		СтруктураПараметров.Организация           = ВладелецФормы.Объект.Организация;
		СтруктураПараметров.Документ              = ВладелецФормы.Объект.Ссылка;
		СтруктураПараметров.ПараметрыСканирования = ПараметрыСканированияШтрихкода(Элементы.СтраницаНовыйКодМаркировки);
		ПечатьЭтикетокИСМПКлиент.РаспечататьНовыйКодМаркировки(Истина, СтруктураПараметров);
		Объект.РезультатВзятьИзПула = Ложь;
		
		Возврат;
		
	Иначе
		
		Если ЗначениеЗаполнено(Объект.НовыйКодМаркировки) Тогда
			УстановитьЗначенияНовогоКодаМаркировки(Объект.КодМаркировки, Объект.НовыйКодМаркировки);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Номенклатура",                    Объект.Номенклатура);
	ВозвращаемоеЗначение.Вставить("Характеристика",                  Объект.Характеристика);
	ВозвращаемоеЗначение.Вставить("НоваяНоменклатура",               Объект.НоваяНоменклатура);
	ВозвращаемоеЗначение.Вставить("НоваяХарактеристика",             Объект.НоваяХарактеристика);
	ВозвращаемоеЗначение.Вставить("КодМаркировки",                   Объект.КодМаркировки);
	ВозвращаемоеЗначение.Вставить("НовыйКодМаркировки",              Объект.НовыйКодМаркировки);
	ВозвращаемоеЗначение.Вставить("ПричинаПеремаркировки",           Объект.ПричинаПеремаркировки);
	ВозвращаемоеЗначение.Вставить("ХарактеристикиИспользуются",      Объект.ХарактеристикиИспользуются);
	ВозвращаемоеЗначение.Вставить("НоваяХарактеристикаИспользуется", Объект.НоваяХарактеристикаИспользуется);
	ВозвращаемоеЗначение.Вставить("СпособВводаВОборот",              Объект.СпособВводаВОборот);
	ВозвращаемоеЗначение.Вставить("НовыйСпособВводаВОборот",         Объект.НовыйСпособВводаВОборот);
	ВозвращаемоеЗначение.Вставить("Серия",                           Объект.Серия);
	ВозвращаемоеЗначение.Вставить("НоваяСерия",                      Объект.НоваяСерия);
	ВозвращаемоеЗначение.Вставить("МаркировкаОстатков",              Объект.МаркировкаОстатков);
	
	АдресРезультатаПриЗакрытии = ПоместитьВоВременноеХранилище(ВозвращаемоеЗначение, УникальныйИдентификатор);
	
	ПодключитьОбработчикОжидания("ЗакрытьФормуПриСканировании", 0.1, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФормуПриСканировании()
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультатаПриЗакрытии);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура РаспечататьНовыйКодЗавершение(ДанныеОтветаРезервированияИПечати, ДополнительныеПараметры) Экспорт
	
	Если ДанныеОтветаРезервированияИПечати = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеОтветаРезервированияИПечати.РезультатРезервирования.Количество() Тогда
		
		СтрокаРезультата = ДанныеОтветаРезервированияИПечати.РезультатРезервирования.Получить(0);
		
		СтруктураДополнительныхПараметров = Новый Структура();
		СтруктураДополнительныхПараметров.Вставить("ОтключитьКонтрольСтатусов", Истина);
		СтруктураДополнительныхПараметров.Вставить("КонтролироватьВладельца",   Ложь);
		
		Если ДанныеОтветаРезервированияИПечати.СохраняемыеНастройки.ЗапомнитьВыбор Тогда
			
			СохраняемыеДанные = ШтрихкодированиеИСКлиент.ИнициализацияСтруктурыДанныхСохраненногоВыбора();
			ДанныеВыбора = ДанныеОтветаРезервированияИПечати.СохраняемыеНастройки.ДанныеВыбора;
			ЗаполнитьЗначенияСвойств(СохраняемыеДанные.ДанныеВыбора, ДанныеВыбора);
			ЗаполнитьЗначенияСвойств(СохраняемыеДанные.ДанныеВыбора, Объект,, "ШаблонЭтикетки,СразуНаПринтер,Серия");
			
			ШтрихкодированиеИСКлиентСервер.ОбработатьСохраненныйВыборДанныхПоМаркируемойПродукции(
				ВладелецФормы, СохраняемыеДанные.ДанныеВыбора, Истина);
				
		КонецЕсли;
		
		СтруктураДополнительныхПараметров.Вставить("ДанныеУточнения", ДанныеОтветаРезервированияИПечати.СохраняемыеНастройки.ДанныеВыбора);
		СтруктураДополнительныхПараметров.Вставить("ТекущаяСтраница", Элементы.СтраницаНовыйКодМаркировки);
		
		ДанныеШтрихкода = Новый Структура("Штрихкод, Количество", СтрокаРезультата.КодМаркировки, 1);
		РучнойВводШтрихкодаЗавершение(ДанныеШтрихкода, СтруктураДополнительныхПараметров);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ШагДалееПроверитьИПереключитьСтраницу(НоваяСтраница)
	
	Отказ = Ложь;
	
	СтрукутраВозможныхПроверок = Новый Структура();
	СтрукутраВозможныхПроверок.Вставить("ПричинаПеремаркировки", Ложь);
	СтрукутраВозможныхПроверок.Вставить("КодМаркировки",         Ложь);
	СтрукутраВозможныхПроверок.Вставить("НоваяНоменклатура",     Ложь);
	СтрукутраВозможныхПроверок.Вставить("НоваяХарактеристика",   Ложь);
	СтрукутраВозможныхПроверок.Вставить("НовыйКодМаркировки",    Ложь);
	
	Если Элементы.СтраницыДанных.ТекущаяСтраница = Элементы.СтраницаКодМаркировки Тогда
		
		СтрукутраВозможныхПроверок.КодМаркировки         = Истина;
		
	КонецЕсли;
	
	Если Элементы.СтраницыДанных.ТекущаяСтраница = Элементы.СтраницаНовыйКодМаркировки Тогда
		
		Если Объект.ПричинаПеремаркировки = ПредопределенноеЗначение(
			"Перечисление.ПричиныПеремаркировкиТоваровИСМП.ОшибкиОписанияТовара") Тогда
			
			СтрукутраВозможныхПроверок.ПричинаПеремаркировки = Истина;
			СтрукутраВозможныхПроверок.НоваяНоменклатура     = Истина;
			СтрукутраВозможныхПроверок.НоваяХарактеристика   = Истина;
			СтрукутраВозможныхПроверок.НовыйКодМаркировки    = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОчиститьСообщения();
	
	Если СтрукутраВозможныхПроверок.КодМаркировки И Не ЗначениеЗаполнено(Объект.КодМаркировки) Тогда
		ТекстСообщения = НСтр("ru = 'Необходимо заполнить поле ""Код маркировки""'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,, "Объект.КодМаркировки", Отказ);
	КонецЕсли;
	
	Если СтрукутраВозможныхПроверок.ПричинаПеремаркировки И Не ЗначениеЗаполнено(Объект.ПричинаПеремаркировки) Тогда
		ТекстСообщения = НСтр("ru = 'Необходимо заполнить поле ""Причина перемаркировки""'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,, "Объект.ПричинаПеремаркировки", Отказ);
	КонецЕсли;
	
	Если СтрукутраВозможныхПроверок.НоваяНоменклатура И Не ЗначениеЗаполнено(Объект.НоваяНоменклатура) Тогда
		ТекстСообщения = НСтр("ru = 'Необходимо заполнить поле ""Номенклатура""'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"НовоеПредставление",, Отказ);
	КонецЕсли;
	
	Если СтрукутраВозможныхПроверок.НоваяХарактеристика 
		И Объект.НоваяХарактеристикаИспользуется И Не ЗначениеЗаполнено(Объект.НоваяХарактеристика) Тогда
		ТекстСообщения = НСтр("ru = 'Необходимо заполнить поле ""Характеристика""'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"НовоеПредставление", Отказ);
	КонецЕсли;
	
	Если СтрукутраВозможныхПроверок.НовыйКодМаркировки И Не ЗначениеЗаполнено(Объект.НовыйКодМаркировки) Тогда
		ТекстСообщения = НСтр("ru = 'Необходимо заполнить поле ""Новый код маркировки""'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,, "Объект.НовыйКодМаркировки", Отказ);
	КонецЕсли;
	
	Если Не Отказ Тогда
		
		Если Элементы.СтраницыДанных.ТекущаяСтраница = НоваяСтраница Тогда
			ЗавершитьВвод();
		Иначе
			УстановитьТекущуюСтраницу(ЭтотОбъект, НоваяСтраница);
			УстановитьДоступностьЭлементовФормы();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементовФормы()
	
	Элементы.СтраницыДанных.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
	Для Каждого Страница Из Элементы.СтраницыДанных.ПодчиненныеЭлементы Цикл
		ОтображатьСтраницу = Элементы.СтраницыДанных.ТекущаяСтраница = Страница;
		Страница.Видимость = ОтображатьСтраницу;
	КонецЦикла;
	
	ТекущаяСтраница                                  = Элементы.СтраницыДанных.ТекущаяСтраница;
	Заголовок                                        = ТекущаяСтраница.Заголовок;
	Элементы.Назад.Видимость                         = Истина;
	Элементы.РаспечататьНовыйКодМаркировки.Видимость = Ложь;
	Элементы.Готово.Заголовок                        = "Далее";
	
	Если ТекущаяСтраница = Элементы.СтраницаНовыйКодМаркировки Тогда
		Элементы.РаспечататьНовыйКодМаркировки.Видимость = Истина;
		Элементы.Готово.Заголовок = "Готово";
		Элементы.Готово.Доступность = НЕ Объект.БлокировкаРедактированияНовогоКода;
	ИначеЕсли ТекущаяСтраница = Элементы.СтраницаКодМаркировки Тогда
		Элементы.Назад.Видимость = Ложь;
		Элементы.Готово.Доступность = Истина;
	КонецЕсли;
	
	Элементы.РаспечататьНовыйКодМаркировки.Доступность = Не Объект.БлокировкаРедактированияНовогоКода;
	Элементы.ПоискПоШтрихкоду.Доступность              = НЕ Объект.БлокировкаРедактированияСтарогоКода;
	Элементы.НовыйПоискПоШтрихкоду.Доступность         = НЕ Объект.БлокировкаРедактированияНовогоКода;
	Элементы.СтраницаКодМаркировки.ТолькоПросмотр      = Объект.БлокировкаРедактированияСтарогоКода;
	Элементы.СтраницаНовыйКодМаркировки.ТолькоПросмотр = Объект.БлокировкаРедактированияНовогоКода;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОпределитьТекущийШаг(Форма)
	
	Если Не ЗначениеЗаполнено(Форма.Объект.КодМаркировки) Тогда
		НоваяСтраница = Форма.Элементы.СтраницаКодМаркировки;
	Иначе
		НоваяСтраница = Форма.Элементы.СтраницаНовыйКодМаркировки;
	КонецЕсли;
	
	УстановитьТекущуюСтраницу(Форма, НоваяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеВыборПоНавигационнойСсылкеВФормеВводаКодаМаркировки(Значение, ДополнительныеПараметры) Экспорт
	
	Если Значение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.НавигационнаяСсылка = "ВыбратьНоменклатуру" Тогда
		
		Объект[ДополнительныеПараметры.СтруктураПолей.Номенклатура]   = Значение;
		Объект[ДополнительныеПараметры.СтруктураПолей.Характеристика] = Неопределено;
		
		СобытияФормИСМПКлиент.ОпределитьИспользованиеХарактеристик(
			ЭтотОбъект,
			Объект,
			ДополнительныеПараметры.СтруктураПолей.Номенклатура,
			ДополнительныеПараметры.СтруктураПолей.ХарактеристикаИспользуется);
		
	ИначеЕсли ДополнительныеПараметры.НавигационнаяСсылка = "ВыбратьХарактеристику" Тогда
		
		Объект[ДополнительныеПараметры.СтруктураПолей.Характеристика] = Значение;
		
	КонецЕсли;
	
	УстановитьПараметрыВыбораШтрихкодыУпаковок(ДополнительныеПараметры.СтруктураПолей);
	
	ОбновитьПредставленияНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВыбораШтрихкодыУпаковок(СтруктураПолей)
	
	СвязиВыбора = Новый Массив();
	
	Если ЗначениеЗаполнено(Объект[СтруктураПолей.Номенклатура]) Тогда
		СвязиВыбора.Добавить(
			Новый СвязьПараметраВыбора("Отбор.Номенклатура", СтрШаблон("Объект.%1", СтруктураПолей.Номенклатура)));
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект[СтруктураПолей.Характеристика]) Тогда
		СвязиВыбора.Добавить(
			Новый СвязьПараметраВыбора("Отбор.Характеристика", СтрШаблон("Объект.%1", СтруктураПолей.Характеристика)));
	КонецЕсли;
	
	Элементы[СтруктураПолей.КодМаркировки].СвязиПараметровВыбора = Новый ФиксированныйМассив(СвязиВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаПричиныПеремаркировки()
	
	Если Объект.ПричинаПеремаркировки = ПредопределенноеЗначение(
		"Перечисление.ПричиныПеремаркировкиТоваровИСМП.ИспорченоУтраченоСИКМ") Тогда
		
		Если Не Объект.НоваяНоменклатура = Объект.Номенклатура 
			И Не Объект.НоваяХарактеристика = Объект.Характеристика Тогда
			Объект.НовыйКодМаркировки = Неопределено;
		КонецЕсли;
		
		Объект.НоваяНоменклатура = Объект.Номенклатура;
		Объект.НоваяХарактеристика = Объект.Характеристика;
		Объект.НоваяХарактеристикаИспользуется = Объект.ХарактеристикиИспользуются;
		
	КонецЕсли;
	
	ОбновитьПредставленияНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СтруктураПолейПоРежиму(НовыйКод=Ложь)
	
	СтруктураПолей = Новый Структура();
	
	Если НовыйКод Тогда
		СтруктураПолей.Вставить("Номенклатура",               "НоваяНоменклатура");
		СтруктураПолей.Вставить("Характеристика",             "НоваяХарактеристика");
		СтруктураПолей.Вставить("ХарактеристикаИспользуется", "НоваяХарактеристикаИспользуется");
		СтруктураПолей.Вставить("Представление",              "НовоеПредставление");
		СтруктураПолей.Вставить("КодМаркировки",              "НовыйКодМаркировки");
		СтруктураПолей.Вставить("СпособВводаВОборот",         "НовыйСпособВводаВОборот");
	Иначе
		СтруктураПолей.Вставить("Номенклатура",               "Номенклатура");
		СтруктураПолей.Вставить("Характеристика",             "Характеристика");
		СтруктураПолей.Вставить("ХарактеристикаИспользуется", "ХарактеристикиИспользуются");
		СтруктураПолей.Вставить("Представление",              "Представление");
		СтруктураПолей.Вставить("КодМаркировки",              "КодМаркировки");
		СтруктураПолей.Вставить("СпособВводаВОборот",         "СпособВводаВОборот");
	КонецЕсли;
	
	Возврат СтруктураПолей;
	
КонецФункции

#Область ШтрихкодыИТорговоеОборудование

&НаСервереБезКонтекста
Процедура УстановитьЗначенияНовогоКодаМаркировки(КодМаркировки, НовыйКодМаркировки)
	
	Обработки.РаботаСКМПриПеремаркировкеТоваровИСМП.УстановитьЗначенияНовогоКодаМаркировки(
		КодМаркировки, НовыйКодМаркировки);
	
КонецПроцедуры

&НаКлиенте
Процедура РучнойВводШтрихкодаЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(ДополнительныеПараметры) <> Тип("Структура") Тогда
		ДополнительныеПараметры = Новый Структура("ТекущаяСтраница", ДополнительныеПараметры);
	КонецЕсли;
	
	ПараметрыСканирования   = ПараметрыСканированияШтрихкода(ДополнительныеПараметры.ТекущаяСтраница);
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ШтрихкодированиеИСКлиент.ОбработатьДанныеШтрихкода(
		ОповещениеПриЗавершении, ЭтотОбъект, ДанныеШтрихкода, ПараметрыСканирования);
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыСканированияШтрихкода(ТекущаяСтраница)

	ПараметрыСканирования = ШтрихкодированиеИСКлиент.ПараметрыСканирования(ВладелецФормы);
	
	ПараметрыСканирования.ДопустимыеСтатусыИСМП.Очистить();
	
	Если ТекущаяСтраница = Элементы.СтраницаНовыйКодМаркировки Тогда
		
		ПараметрыСканирования.ДопустимыеСтатусыИСМП.Добавить(
			ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиИСМП.Нанесен"));
		ПараметрыСканирования.ДопустимыеСтатусыИСМП.Добавить(
			ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиИСМП.Эмитирован"));
		
		ПараметрыСканирования.ДопустимыйСпособВводаВОборот = Объект.СпособВводаВОборот;
		
		Если Объект.МаркировкаОстатков Тогда
			ПараметрыСканирования.ЭтоМаркировкаОстатков = Истина;
			ПараметрыСканирования.ДопустимыйСпособВводаВОборот = ПредопределенноеЗначение("Перечисление.СпособыВводаВОборотСУЗ.МаркировкаОстатков");
		КонецЕсли;
		
	Иначе
		
		ПараметрыСканирования.ДопустимыеСтатусыИСМП.Добавить(
			ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиИСМП.ВведенВОборот"));
		ПараметрыСканирования.ДопустимыеСтатусыИСМП.Добавить(
			ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиИСМП.ВведенВОборотПриВозврате"));
		ПараметрыСканирования.ДопустимыеСтатусыИСМП.Добавить(
			ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиИСМП.ОжидаетПовторнойМаркировки"));
		
		ПараметрыСканирования.ДопустимыйСпособВводаВОборот = Неопределено;
		ПараметрыСканирования.ЭтоМаркировкаОстатков        = Неопределено;
		
	КонецЕсли;
	
	Возврат ПараметрыСканирования;
	
КонецФункции

//@skip-warning
&НаСервере
Функция Подключаемый_ОбработатьВводШтрихкода(ДанныеШтрихкода, КэшированныеЗначения, ПараметрыСканирования = Неопределено)
	
	РезультатОбработкиШтрихкода = ШтрихкодированиеИС.ОбработатьВводШтрихкода(
		ЭтотОбъект, ДанныеШтрихкода, КэшированныеЗначения, ПараметрыСканирования);
	
	РезультатОбработкиШтрихкода.ИзмененныеСтроки  = Новый Массив;
	РезультатОбработкиШтрихкода.ДобавленныеСтроки = Новый Массив;
	
	Возврат РезультатОбработкиШтрихкода;
	
КонецФункции

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОткрытьФормуУточненияДанных()
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("РучнойВводШтрихкодаЗавершение", ЭтотОбъект);
	ШтрихкодированиеИСКлиент.Подключаемый_ОткрытьФормуУточненияДанных(ЭтотОбъект, ОповещениеПриЗавершении);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	Если Объект.БлокировкаРедактированияСтарогоКода И Объект.БлокировкаРедактированияНовогоКода Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеШтрихкода = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ТекущаяСтраница = Элементы.СтраницаКодМаркировки Тогда
		СтруктураПолей = СтруктураПолейПоРежиму();
		СледующийШаг   = Истина;
	ИначеЕсли ДополнительныеПараметры.ТекущаяСтраница = Элементы.СтраницаНовыйКодМаркировки Тогда
		СтруктураПолей = СтруктураПолейПоРежиму(Истина);
		СледующийШаг   = Ложь;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если ДанныеШтрихкода.ТипУпаковки = ПредопределенноеЗначение("Перечисление.ТипыУпаковок.МаркированныйТовар") Тогда
		
		УспешноОбработано = ОбработатьШтрихкодКодаМаркировки(ДанныеШтрихкода, СтруктураПолей, СледующийШаг);
		
		Если УспешноОбработано И СледующийШаг Тогда
			КомандаДалее();
		КонецЕсли;
	
	ИначеЕсли Не ЗначениеЗаполнено(ДанныеШтрихкода.ТипУпаковки) Тогда
		
		УспешноОбработано = ОбработатьШтрихкодаТовара(ДанныеШтрихкода, СтруктураПолей);
		
	Иначе
		ВывестиСообщениеНаСтраницеВводаКодаМаркировки(
			НСтр("ru = 'Недопустимый формат штрихкода'"));
		Возврат;
	КонецЕсли;
	
	ОбновитьКэшМаркируемойПродукции();
	
	ОбновитьПредставленияНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Функция ОбработатьШтрихкодКодаМаркировки(ДанныеШтрихкода, СтруктураПолей, СледующийШаг)
	
	Номенклатура              = Объект[СтруктураПолей.Номенклатура];
	Объект.МаркировкаОстатков = ШтрихкодированиеИСКлиентСервер.ЭтоШтрихкодВводаОстатков(ДанныеШтрихкода.Штрихкод);
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		
		Если ДанныеШтрихкода.Номенклатура <> Номенклатура Тогда
			ВывестиСообщениеНаСтраницеВводаКодаМаркировки(
				СтрШаблон(НСтр(
					"ru = 'Номенклатура отсканированного кода не соответствует: %1'"), ДанныеШтрихкода.Номенклатура));
			Возврат Ложь;
		КонецЕсли;
		
		Характеристика = Объект[СтруктураПолей.Характеристика];
		ХарактеристикаИспользуется = Объект[СтруктураПолей.ХарактеристикаИспользуется];
		
		Если ХарактеристикаИспользуется И ДанныеШтрихкода.Характеристика <> Характеристика Тогда
			ВывестиСообщениеНаСтраницеВводаКодаМаркировки(
				СтрШаблон(НСтр(
					"ru = 'Характеристика отсканированного кода не соответствует: %1'"), ДанныеШтрихкода.Номенклатура));
			Возврат Ложь;
		КонецЕсли;
		
	Иначе
		
		Объект[СтруктураПолей.Номенклатура] = ДанныеШтрихкода.Номенклатура;
		
		СобытияФормИСМПКлиент.ОпределитьИспользованиеХарактеристик(
				ЭтотОбъект,
				Объект,
				СтруктураПолей.Номенклатура,
				СтруктураПолей.ХарактеристикаИспользуется);
				
		Объект[СтруктураПолей.Характеристика] = ДанныеШтрихкода.Характеристика;
		
	КонецЕсли;
	
	Объект[СтруктураПолей.КодМаркировки]        = ДанныеШтрихкода.ШтрихкодУпаковки;
	Объект[СтруктураПолей.СпособВводаВОборот]   = ДанныеШтрихкода.СпособВводаВОборот;
	
	УстановитьПричинуПеремаркировки();
	
	Если ЗначениеЗаполнено(Объект[СтруктураПолей.КодМаркировки])
		И ЗначениеЗаполнено(Объект.ПричинаПеремаркировки) Тогда
		СледующийШаг = Истина;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Функция ОбработатьШтрихкодаТовара(ДанныеШтрихкода, СтруктураПолей)
	
	Если Не Объект[СтруктураПолей.Номенклатура] = ДанныеШтрихкода.Номенклатура
		Или Не Объект[СтруктураПолей.Характеристика] = ДанныеШтрихкода.Характеристика Тогда
		Объект[СтруктураПолей.КодМаркировки]  = Неопределено;
	КонецЕсли;
	
	Объект[СтруктураПолей.Номенклатура]   = ДанныеШтрихкода.Номенклатура;
	Объект[СтруктураПолей.Характеристика] = ДанныеШтрихкода.Характеристика;
	СобытияФормИСМПКлиент.ОпределитьИспользованиеХарактеристик(
				ЭтотОбъект,
				Объект,
				СтруктураПолей.Номенклатура,
				СтруктураПолей.ХарактеристикаИспользуется);
	
	КодМаркировкиПриИзмененииСервер();
	
	УстановитьПричинуПеремаркировки();
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область Прочее

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТекущуюСтраницу(Форма, НоваяСтраница)
	
	Если Не НоваяСтраница.Видимость Тогда
		НоваяСтраница.Видимость = Истина;
	КонецЕсли;
	
	Форма.Элементы.СтраницыДанных.ТекущаяСтраница = НоваяСтраница;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметрыПослеИзмененияКодаМаркировки()
	
	Если Элементы.СтраницыДанных.ТекущаяСтраница = Элементы.СтраницаКодМаркировки Тогда
		СтруктураПолей = СтруктураПолейПоРежиму();
	ИначеЕсли Элементы.СтраницыДанных.ТекущаяСтраница = Элементы.СтраницаНовыйКодМаркировки Тогда
		СтруктураПолей = СтруктураПолейПоРежиму(Истина);
	Иначе
		Возврат;
	КонецЕсли;
		
	СобытияФормИСМПКлиент.ОпределитьИспользованиеХарактеристик(
		ЭтотОбъект,
		Объект,
		СтруктураПолей.Номенклатура,
		СтруктураПолей.ХарактеристикаИспользуется);
		
	ОбновитьПредставленияНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПричинуПеремаркировки()
	
	Если Не ЗначениеЗаполнено(Объект.Номенклатура)
		Или Не ЗначениеЗаполнено(Объект.НоваяНоменклатура) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполненаХарактеристика = ЗначениеЗаполнено(Объект.Характеристика)
		И Объект.ХарактеристикиИспользуются Или Не Объект.ХарактеристикиИспользуются;
	ЗаполненаНоваяХарактеристика = ЗначениеЗаполнено(Объект.НоваяХарактеристика)
		И Объект.НоваяХарактеристикаИспользуется Или Не Объект.НоваяХарактеристикаИспользуется;
		
	Если Не (ЗаполненаХарактеристика И ЗаполненаНоваяХарактеристика) Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Номенклатура = Объект.НоваяНоменклатура Тогда
		
		ЗначениеХарактеристики = ?(Объект.ХарактеристикиИспользуются, Объект.Характеристика, Неопределено);
		ЗначениеНовойХарактеристики = ?(Объект.НоваяХарактеристикаИспользуется,
			Объект.НоваяХарактеристика, Неопределено);
		Если Не ЗначениеХарактеристики = ЗначениеНовойХарактеристики Тогда
			Объект.ПричинаПеремаркировки = ПредопределенноеЗначение(
			"Перечисление.ПричиныПеремаркировкиТоваровИСМП.ОшибкиОписанияТовара");
			Возврат;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Объект.ПричинаПеремаркировки) Тогда
			Объект.ПричинаПеремаркировки = ПредопределенноеЗначение(
				"Перечисление.ПричиныПеремаркировкиТоваровИСМП.ИспорченоУтраченоСИКМ");
		КонецЕсли;
		
	Иначе
		
		Объект.ПричинаПеремаркировки = ПредопределенноеЗначение(
			"Перечисление.ПричиныПеремаркировкиТоваровИСМП.ОшибкиОписанияТовара");
		Возврат;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура КодМаркировкиПриИзмененииСервер()
	
	Если Элементы.СтраницыДанных.ТекущаяСтраница = Элементы.СтраницаКодМаркировки Тогда
		СтруктураПолей = СтруктураПолейПоРежиму();
	ИначеЕсли Элементы.СтраницыДанных.ТекущаяСтраница = Элементы.СтраницаНовыйКодМаркировки Тогда
		СтруктураПолей = СтруктураПолейПоРежиму(Истина);
	Иначе
		Возврат;
	КонецЕсли;
	
	ВыбранноеЗначение = Объект[СтруктураПолей.КодМаркировки];
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		
		ЗначенияРеквизиов                     = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ВыбранноеЗначение, "Номенклатура, Характеристика");
		
		Объект[СтруктураПолей.Номенклатура]   = ЗначенияРеквизиов.Номенклатура;
		Объект[СтруктураПолей.Характеристика] = ЗначенияРеквизиов.Характеристика;
	
		УстановитьПараметрыВыбораШтрихкодыУпаковок(СтруктураПолей);
	
	КонецЕсли;
	
	ВывестиСообщениеНаСтраницеВводаКодаМаркировки("");
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПредставленияНоменклатуры(Форма)
	
	ПараметрыПредставленияНоменклатуры = ИнтеграцияИСКлиентСервер.ПараметрыПредставленияНоменклатуры();
	ПараметрыПредставленияНоменклатуры.Номенклатура               = Форма.Объект.Номенклатура;
	ПараметрыПредставленияНоменклатуры.Характеристика             = Форма.Объект.Характеристика;
	ПараметрыПредставленияНоменклатуры.ХарактеристикиИспользуются = Форма.Объект.ХарактеристикиИспользуются;
	ПараметрыПредставленияНоменклатуры.ТолькоПросмотр             = Форма.Объект.БлокировкаРедактированияСтарогоКода;
	
	Форма.Представление = ИнтеграцияИСКлиентСервер.ПредставлениеНоменклатурыФорматированнойСтрокой(
		ПараметрыПредставленияНоменклатуры);
	
	Если Форма.Объект.БлокировкаРедактированияНовогоКода Тогда
		ТолькоПросмотрНовойНоменклатуры = Истина;
	Иначе
		ТолькоПросмотрНовойНоменклатуры = Форма.Объект.ПричинаПеремаркировки = ПредопределенноеЗначение(
			"Перечисление.ПричиныПеремаркировкиТоваровИСМП.ИспорченоУтраченоСИКМ");
	КонецЕсли;
	
	ПараметрыПредставленияНоменклатуры = ИнтеграцияИСКлиентСервер.ПараметрыПредставленияНоменклатуры();
	ПараметрыПредставленияНоменклатуры.Номенклатура               = Форма.Объект.НоваяНоменклатура;
	ПараметрыПредставленияНоменклатуры.Характеристика             = Форма.Объект.НоваяХарактеристика;
	ПараметрыПредставленияНоменклатуры.ХарактеристикиИспользуются = Форма.Объект.НоваяХарактеристикаИспользуется;
	ПараметрыПредставленияНоменклатуры.ТолькоПросмотр             = ТолькоПросмотрНовойНоменклатуры;
	
	Форма.НовоеПредставление = ИнтеграцияИСКлиентСервер.ПредставлениеНоменклатурыФорматированнойСтрокой(
		ПараметрыПредставленияНоменклатуры);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТоварыИсточник()
	
	Если ВладелецФормы <> Неопределено Тогда
		Для Каждого СтрокаТовары Из ВладелецФормы.Объект.Товары Цикл
			НоваяСтрока = Объект.ТоварыИсточник.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТовары);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаДалее()
	
	ТекущаяСтраница = Элементы.СтраницыДанных.ТекущаяСтраница;
	Страницы        = Элементы.СтраницыДанных.ПодчиненныеЭлементы;
	
	НоваяСтраница = Неопределено;
	
	Для Каждого Страница Из Страницы Цикл
		Если Страница = ТекущаяСтраница Тогда
			НоваяСтраница = Страница; // Определяем флаг текущей страницы
		ИначеЕсли НоваяСтраница <> Неопределено Тогда
			НоваяСтраница = Страница;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НоваяСтраница = Неопределено Тогда
		НоваяСтраница = Элементы.СтраницыДанных.ТекущаяСтраница;
	КонецЕсли;
	
	ШагДалееПроверитьИПереключитьСтраницу(НоваяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад()
	
	ТекущаяСтраница = Элементы.СтраницыДанных.ТекущаяСтраница;
	
	НоваяСтраница = ТекущаяСтраница;
	Для Каждого Страница Из Элементы.СтраницыДанных.ПодчиненныеЭлементы Цикл
		Если Страница = ТекущаяСтраница Тогда // Это первая страница - ничего не делаем
			Прервать;
		Иначе
			НоваяСтраница = Страница;
		КонецЕсли;
	КонецЦикла;
	
	Если Элементы.СтраницыДанных.ТекущаяСтраница <> НоваяСтраница Тогда
		УстановитьТекущуюСтраницу(ЭтотОбъект, НоваяСтраница);
		УстановитьДоступностьЭлементовФормы();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВывестиСообщениеНаСтраницеВводаКодаМаркировки(Знач ТекстСообщения)
	
	ТекстСообщения = СокрЛП(ТекстСообщения);
	ДобавитьЭлементДекорацияНаФорму();
	Элементы.ИнформацияВводаКодаМаркировки.Заголовок = ТекстСообщения;
	Элементы.ИнформацияВводаКодаМаркировки.Видимость = ЗначениеЗаполнено(ТекстСообщения);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьЭлементДекорацияНаФорму()
	
	ИмяЭлемента = "ИнформацияВводаКодаМаркировки";
	
	Если Элементы.Найти(ИмяЭлемента) = Неопределено Тогда
		Элемент = Элементы.Добавить(ИмяЭлемента, Тип("ДекорацияФормы"), Элементы.ГруппаИнформация);
		Элемент.АвтоМаксимальнаяШирина = Ложь;
		Элемент.ЦветТекста = ЦветаСтиля.СтатусОбработкиОшибкаПередачиГосИС;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти