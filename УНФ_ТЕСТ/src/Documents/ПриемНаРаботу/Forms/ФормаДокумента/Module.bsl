
#Область ОбработчикиСлужебные

&НаКлиенте
Процедура ОбработатьИзмененияРеквизитовПечати(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		
		ПечатьДокументовУНФКлиент.ОбновитьЗначенияРеквизитовПечати(ЭтотОбъект, Результат.ИзмененныеРеквизиты);
		
		Если Результат.Свойство("Команда") Тогда
			
			Подключаемый_ВыполнитьКоманду(Результат.Команда);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьТекущегоСотрудника()
	
	Элементы.Сотрудники.ТекущаяСтрока = ТекущийСотрудник;
	
	#Если МобильныйКлиент Тогда
		
		УправлениеНебольшойФирмойКлиент.УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ЭтаФорма, "НачисленияУдержания");
		УправлениеНебольшойФирмойКлиент.УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ЭтаФорма, "НалогиНаДоходы");
		
	#КонецЕсли
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеДатаПриИзменении(ДокументСсылка, ДатаНовая, ДатаПередИзменением)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("РазностьДат", УправлениеНебольшойФирмойСервер.ПроверитьНомерДокумента(ДокументСсылка, ДатаНовая, ДатаПередИзменением));
	
	Возврат СтруктураДанные;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеОрганизацияПриИзменении(Организация)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("Компания", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Организация));
	СтруктураДанные.Вставить("ПодписьРуководителя", Организация.ПодписьРуководителя);
	
	Возврат СтруктураДанные;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокВыбораТекущихСотрудников()
	
	Элементы.ТекущийСотрудникНачисленияУдержания.СписокВыбора.Очистить();
	Элементы.ТекущийСотрудникНалоги.СписокВыбора.Очистить();
	Для каждого СтрокаСотрудник Из Объект.Сотрудники Цикл
		
		ПредставлениеСтроки = Строка(СтрокаСотрудник.Сотрудник) + НСтр("ru =', ТН: '") + Строка(СтрокаСотрудник.Сотрудник.Код);
		Элементы.ТекущийСотрудникНачисленияУдержания.СписокВыбора.Добавить(СтрокаСотрудник.ПолучитьИдентификатор(), ПредставлениеСтроки);
		Элементы.ТекущийСотрудникНалоги.СписокВыбора.Добавить(СтрокаСотрудник.ПолучитьИдентификатор(), ПредставлениеСтроки);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьВкладок()
	
	Если Объект.Организация.ИспользуетсяОтчетность Тогда
		Элементы.СтраницаНалоги.Видимость = Ложь;
	Иначе
		Элементы.СтраницаНалоги.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОтображениеПодсказки(Элементы, Показать)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаПодсказкаАссистента",
		"Видимость",
		Показать);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДата();
	КонецЕсли;
	
	Компания = УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Объект.Организация);
	ИмяТабличнойЧасти = "Сотрудники";
	ВалютаПоУмолчанию = Константы.НациональнаяВалюта.Получить();
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьСовместительство") Тогда
		
		Если Элементы.Найти("СотрудникиСотрудникКод") <> Неопределено Тогда
			
			Элементы.СотрудникиСотрудникКод.Видимость = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Пользователь = Пользователи.ТекущийПользователь();
	
	ЗначениеНастройки = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь, "ОсновноеПодразделение");
	ОсновноеПодразделение = ?(ЗначениеЗаполнено(ЗначениеНастройки), ЗначениеНастройки, Справочники.СтруктурныеЕдиницы.ОсновноеПодразделение);
	
	УчетНалогов = ПолучитьФункциональнуюОпцию("ВестиУчетНалогаНаДоходыИВзносов");
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ТекущийСотрудникНалоги", "Видимость", УчетНалогов);
	Если НЕ УчетНалогов Тогда
		
		Элементы.Сотрудники.РасширеннаяПодсказка.Заголовок = 
			НСтр("ru = 'Начисления и удержания указываются на соответствующей странице для каждого сотрудника в отдельности.'");
			
	КонецЕсли;
	
	УправлениеНебольшойФирмойСервер.УстановитьОтображаниеПодменюПечати(Элементы.ПодменюПечать);
	
	ИзменитьОтображениеПодсказки(Элементы, Не ЗначениеЗаполнено(Объект.Ссылка)И ПолучитьФункциональнуюОпцию("ИспользоватьОтчетность"));
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	УстановитьВидимостьВкладок();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ИзменениеПоКадровомуУчету");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_Организации" И Источник = Объект.Организация Тогда
		УстановитьВидимостьВкладок();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРеквизитов

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Объект.Номер = "";
	
	СтруктураДанные = ПолучитьДанныеОрганизацияПриИзменении(Объект.Организация);
	Компания = СтруктураДанные.Компания;
	Объект.ПодписьРуководителя = СтруктураДанные.ПодписьРуководителя;
	
	УстановитьВидимостьВкладок();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыОсновнаяПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.СтраницаНачисленияУдержания
		ИЛИ ТекущаяСтраница = Элементы.СтраницаНалоги Тогда
		
		ЗаполнитьСписокВыбораТекущихСотрудников();
		
		ДанныеТекущейСтроки = Элементы.Сотрудники.ТекущиеДанные;
		
		Если ДанныеТекущейСтроки <> Неопределено Тогда
			
			ТекущийСотрудник = ДанныеТекущейСтроки.ПолучитьИдентификатор();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекущийСотрудникНачисленияУдержанияПриИзменении(Элемент)
	
	ИзменитьТекущегоСотрудника();
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияУдержанияСчетЗатратНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаИПерсоналКлиент.ПараметрыВыбораСчетаЗатрат(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекущийСотрудникНалогиПриИзменении(Элемент)
	
	ИзменитьТекущегоСотрудника();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПриАктивизацииСтроки(Элемент)
	
	УправлениеНебольшойФирмойКлиент.УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ЭтаФорма, "НачисленияУдержания");
	УправлениеНебольшойФирмойКлиент.УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ЭтаФорма, "НалогиНаДоходы");
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		УправлениеНебольшойФирмойКлиент.ДобавитьКлючСвязиВСтрокуТабличнойЧасти(ЭтаФорма);
		УправлениеНебольшойФирмойКлиент.УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ЭтаФорма, "НачисленияУдержания");
		УправлениеНебольшойФирмойКлиент.УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ЭтаФорма, "НалогиНаДоходы");
		
		СтрокаТабличнойЧасти = Элементы.Сотрудники.ТекущиеДанные;
		Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтруктурнаяЕдиница) Тогда
			
			СтрокаТабличнойЧасти.СтруктурнаяЕдиница = ОсновноеПодразделение;
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередУдалением(Элемент, Отказ)

	УправлениеНебольшойФирмойКлиент.УдалитьСтрокиПодчиненнойТабличнойЧасти(ЭтаФорма, "НачисленияУдержания");
    УправлениеНебольшойФирмойКлиент.УдалитьСтрокиПодчиненнойТабличнойЧасти(ЭтаФорма, "НалогиНаДоходы");


КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	
	Элементы.Сотрудники.ТекущиеДанные.ЗанимаемыхСтавок = 1;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияУдержанияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		УправлениеНебольшойФирмойКлиент.ДобавитьКлючСвязиВСтрокуПодчиненнойТабличнойЧасти(ЭтаФорма, Элемент.Имя);
		СтрокаТабличнойЧасти = Элементы.НачисленияУдержания.ТекущиеДанные;
		СтрокаТабличнойЧасти.Валюта = ВалютаПоУмолчанию;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НачисленияУдержанияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = УправлениеНебольшойФирмойКлиент.ПередНачаломДобавленияВПодчиненнуюТабличнуюЧасть(ЭтаФорма, Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияУдержанияВидНачисленияУдержанияПриИзменении(Элемент)
	
	ЗарплатаИПерсоналКлиент.СчетЗатратПоУмолчаниюВТекущуюСтроку(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НалогиНаДоходыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		УправлениеНебольшойФирмойКлиент.ДобавитьКлючСвязиВСтрокуПодчиненнойТабличнойЧасти(ЭтаФорма, Элемент.Имя);
		СтрокаТабличнойЧасти = Элементы.НалогиНаДоходы.ТекущиеДанные;
		СтрокаТабличнойЧасти.Валюта = ВалютаПоУмолчанию;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НалогиНаДоходыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = УправлениеНебольшойФирмойКлиент.ПередНачаломДобавленияВПодчиненнуюТабличнуюЧасть(ЭтаФорма, Элемент.Имя);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура ДекорацияПечатьНажатие(Элемент)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьИзмененияРеквизитовПечати", ЭтотОбъект);
	ОткрытьФорму("Обработка.РеквизитыПечати.Форма.РеквизитыПечатиПриемНаРаботу", Новый Структура("КонтекстПечати", Объект), ЭтотОбъект, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЗакрытьПодсказкуНажатие(Элемент)
	
	ИзменитьОтображениеПодсказки(Элементы, Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек


// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
		
КонецПроцедуры

#КонецОбласти



