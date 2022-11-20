
#Область ОписаниеПеременных

&НаКлиенте
Перем МассивИзмененныхРеквизитов;

#КонецОбласти

#Область Служебные

&НаКлиенте
Процедура ИзменитьЗаголовокСвернутойГруппы()
	
	ШаблонЗаголовка = НСтр("ru ='Основание печати: %1'");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаОснованиеПечати", "ЗаголовокСвернутогоОтображения", СтрШаблон(ШаблонЗаголовка, КонтекстПечати.ОснованиеПечати));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗафиксироватьИзменениеЗначенияРеквизита(ИмяРеквизита)
	
	Если МассивИзмененныхРеквизитов.Найти(ИмяРеквизита) = Неопределено Тогда
		
		МассивИзмененныхРеквизитов.Добавить(ИмяРеквизита);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИзмененияИЗакрытьФорму(Команда = Неопределено)
	
	ПараметрыЗакрытия = Новый Структура;
	Если Команда <> Неопределено Тогда
		
		ПараметрыЗакрытия.Вставить("Команда", Команда);
		
	КонецЕсли;
	
	ИзмененныеРеквизиты = Новый Структура;
	Для каждого ЭлементМассива Из МассивИзмененныхРеквизитов Цикл
		
		ИзмененныеРеквизиты.Вставить(ЭлементМассива, КонтекстПечати[ЭлементМассива]);
		
	КонецЦикла;
	ПараметрыЗакрытия.Вставить("ИзмененныеРеквизиты", ИзмененныеРеквизиты);
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаСервере
Процедура ЗаголовокФормы()
	
	ЭтаФорма.Заголовок = Обработки.РеквизитыПечати.ЗаголовокФормы();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораАдресаДоставки(ЭлементАдреса, Владелец, ВидыКИ, МожноИзменитьПоле)
	
	МассивВладельцев = Новый Массив;
	МассивВладельцев.Добавить(Владелец);
	
	Адреса = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(МассивВладельцев, , ВидыКИ);
	Адреса.Сортировать("Вид Возр");
	
	Для Каждого Адрес Из Адреса Цикл
		
		ЭлементАдреса.СписокВыбора.Добавить(Адрес.Представление);
		
		Если МожноИзменитьПоле
			И ПустаяСтрока(КонтекстПечати.АдресДоставки) Тогда
			
			КонтекстПечати.АдресДоставки = Адрес.Представление;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАдресДоставки(ОчиститьПоле = Ложь)
	
	Если ОчиститьПоле Тогда
		
		КонтекстПечати.АдресДоставки = "";
		
	КонецЕсли;
	
	Элементы.АдресДоставки.СписокВыбора.Очистить();
	
	ВидыКИ = Новый Массив;
	ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.ФактАдресКонтрагента);
	ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.АдресДоставкиКонтрагета);
	
	ИсточникАдресовДоставки = ?(ЗначениеЗаполнено(КонтекстПечати.Грузополучатель), КонтекстПечати.Грузополучатель, КонтекстПечати.Контрагент);
	ЗаполнитьСписокВыбораАдресаДоставки(Элементы.АдресДоставки, ИсточникАдресовДоставки, ВидыКИ, ОчиститьПоле);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьПодписиПоУмолчаниюНаСервере()
	
	ДокументОбъект = ДанныеФормыВЗначение(КонтекстПечати, Тип("ДокументОбъект.РасходнаяНакладная"));
	Обработки.РеквизитыПечати.ПодписиПоУмолчанию(ДокументОбъект);
	ЗначениеВДанныеФормы(ДокументОбъект, КонтекстПечати);
	
	КонтекстПечати.КонтактноеЛицоПодписант = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КонтекстПечати.Контрагент, "КонтактноеЛицоПодписант");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОснованияПечати(Параметры)
	
	СписокВыбораЭлемента = Элементы.ОснованиеПечатиСсылка.СписокВыбора;
	
	Если ЗначениеЗаполнено(КонтекстПечати.Договор) Тогда
		
		СписокВыбораЭлемента.Добавить(КонтекстПечати.Договор, ПечатьДокументовУНФ.ПредставлениеОснованияПечати(КонтекстПечати.Договор));
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КонтекстПечати.Заказ)
		И ТипЗнч(КонтекстПечати.Заказ) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		
		СписокВыбораЭлемента.Добавить(КонтекстПечати.Заказ, ПечатьДокументовУНФ.ПредставлениеОснованияПечати(КонтекстПечати.Заказ));
		
	КонецЕсли;
	
	Если Параметры.Свойство("НаборОснований")
		И Параметры.НаборОснований.Количество() > 0 Тогда
		
		Для каждого СтрокаМассива Из Параметры.НаборОснований Цикл
			
			СписокВыбораЭлемента.Добавить(СтрокаМассива, ПечатьДокументовУНФ.ПредставлениеОснованияПечати(СтрокаМассива));
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыВыбораБанковскогоСчета()
	
	Обработки.РеквизитыПечати.ЗаполнитьПараметрыВыбораБанковскогоСчетаОрганизации(Элементы.БанковскийСчет, КонтекстПечати);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкуПечатиНомераСчетаНаСервере()
	
	Константы.ПравилоЗаполненияНомераСчетаНаОплату.Установить(КонтекстПечати.НомерСчетаНаОплату);
	
КонецПроцедуры

&НаСервере
Процедура ДоступностьКомандФормы()
	
	Если НЕ ПравоДоступа("Изменение", КонтекстПечати.Ссылка.Метаданные()) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаВосстановитьПодписиПоУмолчанию", "Доступность", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "РедактироватьПредставлениеОснованияПечати", "Доступность", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Форма

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МассивОбъектовМетаданных = Новый Массив(1);
	МассивОбъектовМетаданных[0] = Параметры.КонтекстПечати.Ссылка.Метаданные();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = МассивОбъектовМетаданных;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	УправлениеНебольшойФирмойСервер.УстановитьОтображаниеПодменюПечати(Элементы.ПодменюПечать);
	
	ИменаРеквизитов = 
		"Организация, БанковскийСчет, ВалютаДокумента, СтруктурнаяЕдиница, ОснованиеПечатиСсылка, ОснованиеПечати,
		|ПодписьРуководителя, ПодписьГлавногоБухгалтера, ПодписьКладовщика, КонтактноеЛицоПодписант,
		|Грузоотправитель, Грузополучатель, АдресДоставки,
		|УсловияГарантийногоТалона, НомерСчетаНаОплату,
		|ДоверенностьВыдана, ДоверенностьДата, ДоверенностьЛицо, ДоверенностьНомер,
		|ОрганизацияОплачиваетПеревозку, Перевозчик, БанковскийСчетПеревозчика, СрокДоставки, Водитель, Автомобиль, Прицеп,
		|Контрагент, Договор, БанковскийСчетКонтрагента, ДокументОснование, Заказ";
	
	ЗаполнитьЗначенияСвойств(КонтекстПечати, Параметры.КонтекстПечати, ИменаРеквизитов);
	
	ЗаголовокФормы();
	ЗаполнитьАдресДоставки();
	ЗаполнитьОснованияПечати(Параметры);
	ЗаполнитьПараметрыВыбораБанковскогоСчета();
	ДоступностьКомандФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИзменитьЗаголовокСвернутойГруппы();
	
	МассивИзмененныхРеквизитов = Новый Массив;
	
КонецПроцедуры

#КонецОбласти

#Область Библиотеки

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	ЗаписатьИзмененияИЗакрытьФорму(Команда);
	
	Возврат; // работа типового метода не предусмотрена
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, КонтекстПечати);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	
	Возврат; // работа типового метода не предусмотрена
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, КонтекстПечати, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	Возврат; // работа типового метода не предусмотрена
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, КонтекстПечати);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область Команды

&НаКлиенте
Процедура ОК(Команда)
	
	ЗаписатьИзмененияИЗакрытьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьПредставлениеОснованияПечати(Команда)
	
	ЗафиксироватьИзменениеЗначенияРеквизита("ОснованиеПечати");
	
	Если Элементы.ОснованиеПечати.Вид = ВидПоляФормы.ПолеВвода Тогда
		
		Элементы.ОснованиеПечати.Вид = ВидПоляФормы.ПолеНадписи;
		
	Иначе
		
		Элементы.ОснованиеПечати.Вид = ВидПоляФормы.ПолеВвода;
		Элементы.ОснованиеПечати.ПодсказкаВвода = НСтр("ru ='Представление основания печати'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьПодписиПоУмолчанию(Команда)
	
	ПредыдущиеЗначения = Новый Структура("ПодписьРуководителя, ПодписьГлавногоБухгалтера, ПодписьКладовщика, КонтактноеЛицоПодписант");
	ЗаполнитьЗначенияСвойств(ПредыдущиеЗначения, КонтекстПечати);
	
	ПолучитьПодписиПоУмолчаниюНаСервере();
	
	Для каждого ЭлементСтруктуры Из ПредыдущиеЗначения Цикл
		
		Если ЭлементСтруктуры.Значение <> КонтекстПечати[ЭлементСтруктуры.Ключ] Тогда
			
			ЗафиксироватьИзменениеЗначенияРеквизита(ЭлементСтруктуры.Ключ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Реквизиты

&НаКлиенте
Процедура ОснованиеПечатиСсылкаПриИзменении(Элемент)
	
	КонтекстПечати.ОснованиеПечати = Элементы.ОснованиеПечатиСсылка.ТекстРедактирования;
	ИзменитьЗаголовокСвернутойГруппы();
	
	ЗафиксироватьИзменениеЗначенияРеквизита("ОснованиеПечати");
	ЗафиксироватьИзменениеЗначенияРеквизита("ОснованиеПечатиСсылка");
	
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеПечатиПриИзменении(Элемент)
	
	ИзменитьЗаголовокСвернутойГруппы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписьРуководителяПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписьГлавногоБухгалтераПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписьКладовщикаПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактноеЛицоПодписантПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрузоотправительПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрузополучательПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	ЗафиксироватьИзменениеЗначенияРеквизита("АдресДоставки");
	
	ЗаполнитьАдресДоставки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресДоставкиПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверенностьНомерПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверенностьДатаПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверенностьВыданаПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверенностьЛицоПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскийСчетПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскийСчетКонтрагентаПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеревозчикПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскийСчетПеревозчикаПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокДоставкиПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ВодительПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтомобильПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрицепПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОплачиваетПеревозкуПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура УсловияГарантийногоТалонаПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура НомерСчетаНаОплатуПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкуПечатиНомераСчета(Команда)
	
	СохранитьНастройкуПечатиНомераСчетаНаСервере();
	
КонецПроцедуры

#КонецОбласти