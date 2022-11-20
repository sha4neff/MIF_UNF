#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра("ПротоколТекст",НСтр("ru='Показать'"));
	Список.Параметры.УстановитьЗначениеПараметра("ФайлОбменаТекст",НСтр("ru='Открыть'"));
	Список.Параметры.УстановитьЗначениеПараметра("ФайлОбменаТекстЗагрузка",НСтр("ru='Загрузить снова'"));
	Список.Параметры.УстановитьЗначениеПараметра("ФайлОбменаТекстВыгрузка",НСтр("ru='Сохранить на диск'"));
	
	Параметры.Свойство("ОтборТолькоЗагрузкаВ1С", ОтборТолькоЗагрузкаВ1С);
	Параметры.Свойство("ОтборТолькоВыгрузкаИз1С", ОтборТолькоВыгрузкаИз1С);
	
	НастроитьОтборДинамическогоСпискаНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыгрузкаИз1СПриИзменении(Элемент)
	
	НастроитьОтборДинамическогоСпискаНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаВ1СПриИзменении(Элемент)
	
	НастроитьОтборДинамическогоСпискаНаКлиенте();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле.Имя = "Протокол" Тогда
		
		ОткрытьФорму(
			"РегистрСведений.ИсторияРаботыСКлиентомБанка.Форма.ФормаПротокола",
			Новый Структура(
				"Период,Организация,БанковскийСчет",
				ТекущиеДанные.Период,
				ТекущиеДанные.Организация,
				ТекущиеДанные.БанковскийСчет));
		
	ИначеЕсли Поле.Имя = "ФайлОбмена" Тогда
		
		ОткрытьФорму(
			"РегистрСведений.ИсторияРаботыСКлиентомБанка.Форма.ФормаФайла",
			Новый Структура(
				"Период,Организация,БанковскийСчет",
				ТекущиеДанные.Период,
				ТекущиеДанные.Организация,
				ТекущиеДанные.БанковскийСчет));
		
	ИначеЕсли Поле.Имя = "ФайлОбмена1" Тогда
		
		ПараметрыОткрытияФормы = Новый Структура("ЗагрузитьИзИстории,Период,Организация,БанковскийСчет",
				Истина,
				ТекущиеДанные.Период,
				ТекущиеДанные.Организация,
				ТекущиеДанные.БанковскийСчет);
				
		Если ТекущиеДанные.Загрузка Тогда
			ЗагрузитьСнова(ПараметрыОткрытияФормы);
		Иначе
			СохранитьНаДиск(ТекущиеДанные, ПараметрыОткрытияФормы);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузитьСнова(ПараметрыОткрытияФормы)
	
	ОткрытьФорму("Обработка.КлиентБанк.Форма.ФормаЗагрузка", ПараметрыОткрытияФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНаДиск(ТекущиеДанные, ПараметрыОткрытияФормы)
	
	ПараметрыЗаписи = ПолучитьТекстФайлаИКодировку(ПараметрыОткрытияФормы, КлючУникальности);
	Если ПараметрыЗаписи = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Не удалось получить данные из информационной базы!'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ТекстовыйПоток = ПараметрыЗаписи.ТекстовыйПоток;
	
	Попытка
		Результат = ПолучитьФайл(ТекстовыйПоток, "1c_to_kl.txt", Истина);
	Исключение
		ТекстСообщения = НСтр("ru = 'Не удалось записать данные в файл. Возможно, диск защищен от записи.'");
		ПоказатьПредупреждение(Неопределено, ТекстСообщения);
	КонецПопытки
	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТекстФайлаИКодировку(ПараметрыОтбора, Ключ)

	МенеджерЗаписи = РегистрыСведений.ИсторияРаботыСКлиентомБанка.СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.Период = ПараметрыОтбора.Период;
	МенеджерЗаписи.Организация = ПараметрыОтбора.Организация;
	МенеджерЗаписи.БанковскийСчет = ПараметрыОтбора.БанковскийСчет;
	МенеджерЗаписи.Прочитать();
	
	Если НЕ МенеджерЗаписи.Выбран() Тогда
		Отказ = Истина;
		Возврат Неопределено;
	КонецЕсли;
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ТекстФайла", МенеджерЗаписи.ИсходныйФайл.Получить());
	СтруктураВозврата.Вставить("Кодировка", МенеджерЗаписи.Кодировка);
	СтруктураВозврата.Вставить("Загрузка", МенеджерЗаписи.Загрузка);
	
	ТекстовыйПоток = Новый ТекстовыйДокумент;
	ТекстовыйПоток.ДобавитьСтроку(СтруктураВозврата.ТекстФайла);
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("txt");
	Если МенеджерЗаписи.Кодировка = "DOS" Тогда
		ТекстовыйПоток.Записать(ИмяВременногоФайла, КодировкаТекста.OEM);
	Иначе
		ТекстовыйПоток.Записать(ИмяВременногоФайла, КодировкаТекста.ANSI);
	КонецЕсли;
	ТекстовыйПоток = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ИмяВременногоФайла), Ключ);
	
	СтруктураВозврата.Вставить("ТекстовыйПоток", ТекстовыйПоток);
	
	// Удаляем временный файл
	Попытка
		УдалитьФайлы(ИмяВременногоФайла);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка при удалении временного файла.'"), УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат СтруктураВозврата;
	
КонецФункции

// Процедура установки отбора в динамическом списке.
//
&НаКлиенте
Процедура НастроитьОтборДинамическогоСпискаНаКлиенте()
	
	Если ОтборТолькоЗагрузкаВ1С И Не ОтборТолькоВыгрузкаИз1С Тогда
		Список.Отбор.Элементы.Очистить();
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Загрузка", Истина, Истина);
	ИначеЕсли Не ОтборТолькоЗагрузкаВ1С И ОтборТолькоВыгрузкаИз1С Тогда
		Список.Отбор.Элементы.Очистить();
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Загрузка", Ложь, Истина);
	Иначе
		Список.Отбор.Элементы.Очистить();
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Загрузка", Ложь, Ложь);
	КонецЕсли;
	
КонецПроцедуры

// Процедура установки отбора в динамическом списке.
//
&НаСервере
Процедура НастроитьОтборДинамическогоСпискаНаСервере()
	
	Если ОтборТолькоЗагрузкаВ1С И Не ОтборТолькоВыгрузкаИз1С Тогда
		Список.Отбор.Элементы.Очистить();
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Загрузка", Истина, Истина);
	ИначеЕсли Не ОтборТолькоЗагрузкаВ1С И ОтборТолькоВыгрузкаИз1С Тогда
		Список.Отбор.Элементы.Очистить();
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Загрузка", Ложь, Истина);
	Иначе
		Список.Отбор.Элементы.Очистить();
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Загрузка", Ложь, Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
